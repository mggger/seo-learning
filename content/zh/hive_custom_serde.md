---
title: "Apache Hive实现自定义存储格式"
date: 2023-11-23
draft: false
description: "学习如何实现Apache Hive的`ROW FORMAT SERDE`机制"
categories: ["bigdata", "hive"]
tags: ["Apache Hive"]
toc: true
---

# Apache Hive实现自定义存储格式

## 背景

在某些业务场景中，下游处理系统需要直接处理数据文件。虽然Hive官方支持text, orc, parquet等格式，但为了应对更多样化的业务场景，学习如何开发自定义存储格式变得十分重要。Hive目前提供了`ROW FORMAT SERDE`机制来实现这一需求。



## ROW FORMAT SERDE

Hive的`ROW FORMAT SERDE`是一个关键的数据格式化概念，它定义了如何解析和映射存储在Hive表中的数据。SERDE代表序列化和反序列化，这涉及到数据在写入Hive表时和从Hive表读取时的转换过程。



## 快速开始

考虑一种业务场景，我们希望数据本身没有列分隔符，而是采用固定宽度的字段。在Hive中，设置列分隔符为空字符串是不被直接支持的。为了解决这个问题，接下来将实现一个自定义的SerDe。

***

首先从结果出发: 

1. 代码打包后的jar名称为 ``hive-fixed-serde-1.0-SNAPSHOT.jar``

2. 添加自定义serde jar包

```sql
add jar hdfs:///path/hive-fixed-serde-1.0-SNAPSHOT.jar
```

3. 建表指定实现类``org.apache.hadoop.hive.serde2.fixed.FixedLengthTextSerDe``, 且每个字段定长分别为10, 5, 8
```sql
CREATE TABLE fixed_length_table (
  column1 STRING,
  column2 STRING,
  column3 STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.fixed.FixedLengthTextSerDe'
WITH SERDEPROPERTIES (
  "field.lengths"="10,5,8"
)
STORED AS TEXTFILE;
```

4. 当写入数据不满足定长时候,  向后补充空格,  写入
```sql
insert into fixed_length_table values ("1", "1", "1")
```

实际文件内容:
```
1         1    1
```







### 实现 FixedLengthTextSerDe

继承自`org.apache.hadoop.hive.serde2.AbstractSerDe`，需要实现以下方法:

- `initialize`: 创建建表语句中`field.lengths`的配置。
- `getSerDeStats`: 返回统计信息。
- `deserialize`: 将文件内容里的数据转换为Hive的ROW。
- `serialize`: 将Hive的ROW转换为实际写文件的内容。本次目的是将数据补位，按空格补充到规定要求的定长。
- `getSerializedClass`: 仅针对text格式。



完整代码:

```java
package org.apache.hadoop.hive.serde2.fixed;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hive.serde2.AbstractSerDe;
import org.apache.hadoop.hive.serde2.SerDeException;
import org.apache.hadoop.hive.serde2.SerDeStats;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspectorFactory;
import org.apache.hadoop.hive.serde2.objectinspector.StructObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;

public class FixedLengthTextSerDe extends AbstractSerDe {

    private List<Integer> fieldLengths;
    private StructObjectInspector rowOI;
    private ArrayList<Object> row;

    @Override
    public void initialize(Configuration conf, Properties tbl) throws SerDeException {
        // Read the configuration property
        String lengthsStr = tbl.getProperty("field.lengths");
        if (lengthsStr == null || lengthsStr.isEmpty()) {
            throw new SerDeException("This SerDe requires the 'field.lengths' property");
        }

        String[] lengthsArray = lengthsStr.split(",");
        fieldLengths = new ArrayList<>();
        for (String length : lengthsArray) {
            fieldLengths.add(Integer.parseInt(length.trim()));
        }

        // Set up the row ObjectInspector
        ArrayList<String> columnNames = new ArrayList<>(Arrays.asList(tbl.getProperty("columns").split(",")));
        ArrayList<ObjectInspector> columnOIs = new ArrayList<>();
        for (int i = 0; i < fieldLengths.size(); i++) {
            columnOIs.add(PrimitiveObjectInspectorFactory.javaStringObjectInspector);
        }
        rowOI = ObjectInspectorFactory.getStandardStructObjectInspector(columnNames, columnOIs);

        // Initialize row object
        row = new ArrayList<>(fieldLengths.size());
    }

    @Override
    public SerDeStats getSerDeStats() {
        // 返回一个空的 SerDeStats 对象。如果需要，可以在这里添加统计信息。
        return new SerDeStats();
    }

    @Override
    public Object deserialize(Writable blob) throws SerDeException {
        Text rowText = (Text) blob;
        row.clear();
        String rowStr = rowText.toString();

        int startIndex = 0;
        for (int len : fieldLengths) {
            if (startIndex + len > rowStr.length()) {
                throw new SerDeException("Data length shorter than expected.");
            }
            row.add(rowStr.substring(startIndex, startIndex + len));
            startIndex += len;
        }

        return row;
    }

    @Override
    public Writable serialize(Object obj, ObjectInspector objInspector) throws SerDeException {
        // 确保 ObjectInspector 是 StructObjectInspector 类型
        if (!(objInspector instanceof StructObjectInspector)) {
            throw new SerDeException("Expected a StructObjectInspector");
        }

        // 将行数据转换为标准结构
        StructObjectInspector structInspector = (StructObjectInspector) objInspector;
        List<Object> structFields = structInspector.getStructFieldsDataAsList(obj);

        // 检查字段数量是否与预期一致
        if (structFields.size() != fieldLengths.size()) {
            throw new SerDeException("Field count does not match field lengths");
        }

        // 拼接每个字段，根据预定义的长度修剪或填充空格
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < structFields.size(); i++) {
            String fieldData = structFields.get(i).toString();
            int length = fieldLengths.get(i);

            // 截断或填充字段数据以匹配长度
            if (fieldData.length() > length) {
                sb.append(fieldData.substring(0, length));
            } else {
                sb.append(fieldData);
                // 对每个字段单独进行填充
                int paddingLength = length - fieldData.length();
                for (int j = 0; j < paddingLength; j++) {
                    sb.append(' '); // 使用空格填充
                }
            }
        }

        return new Text(sb.toString());
    }


    @Override
    public ObjectInspector getObjectInspector() throws SerDeException {
        return rowOI;
    }

    @Override
    public Class<? extends Writable> getSerializedClass() {
        return Text.class;
    }
}
```



项目地址: https://github.com/mggger/hive-custom-serde

