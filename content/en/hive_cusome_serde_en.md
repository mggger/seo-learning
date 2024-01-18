---
title: "Implementing Custom Storage Formats in Apache Hive"
date: 2023-11-23
draft: false
description: "Learn how to implement the `ROW FORMAT SERDE` mechanism in Apache Hive"
categories: ["bigdata", "hive"]
tags: ["Apache Hive"]
toc: true
---

# Implementing Custom Storage Formats in Apache Hive

## Background

In certain business scenarios, downstream processing systems need to handle data files directly. Although Hive officially supports formats like text, orc, parquet, etc., learning how to develop custom storage formats is crucial for addressing a more diverse range of business scenarios. Hive currently offers the `ROW FORMAT SERDE` mechanism for this purpose.

## ROW FORMAT SERDE

The `ROW FORMAT SERDE` in Hive is a key data formatting concept, defining how to parse and map data stored in Hive tables. SERDE stands for serialization and deserialization, which involves the process of converting data when writing to and reading from Hive tables.

## Quick Start

Consider a business scenario where we want the data itself to have no column separators but to use fixed-width fields. Setting a column separator as an empty string is not directly supported in Hive. To solve this problem, we will implement a custom SerDe.

Starting from the outcome:

1. The jar name after packaging is `hive-fixed-serde-1.0-SNAPSHOT.jar`

2. Add the custom serde jar package

```sql
add jar hdfs:///path/hive-fixed-serde-1.0-SNAPSHOT.jar
```

3. Create a table specifying the implementation class `org.apache.hadoop.hive.serde2.fixed.FixedLengthTextSerDe`, with each field having fixed lengths of 10, 5, 8

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

4. When the data written does not meet the fixed length, add spaces to the end and write
```sql
insert into fixed_length_table values ("1", "1", "1")
```

Actual file content:
```
1         1    1
```


### Implementing FixedLengthTextSerDe

Inherit from `org.apache.hadoop.hive.serde2.AbstractSerDe` and implement the following methods:

- `initialize`: Create the configuration for `field.lengths` in the table creation statement.
- `getSerDeStats`: Return statistics information.
- `deserialize`: Convert the data in the file content to Hive's ROW.
- `serialize`: Convert Hive's ROW to the actual file content. The goal here is to pad the data with spaces to the required fixed length.
- `getSerializedClass`: Specifically for text format.

Complete code:

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

Project address: [https://github.com/mggger/hive-custom-serde](https://github.com/mggger/hive-custom-serde)


