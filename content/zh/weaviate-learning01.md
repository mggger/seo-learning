---
title: "向量数据库：Weaviate"
description: "探索Weaviate，一个可扩展的向量数据库，专为快速准确的语义搜索而设计。与OpenAI集成，用于文本嵌入转换。"
date: 2023-07-07
keywords: ["Weaviate", "Vector Database", "OpenAI", "Semantic Search", "AI Learning"]
categories: ["ai-learning"]
draft: false
language: zh
toc: true
---

# 向量数据库：Weaviate

Weaviate是一个创新的向量数据库，提供了强大的数据存储和检索功能。
- 通过使用向量来索引数据对象，Weaviate可以根据其语义属性存储和检索数据对象。
- Weaviate可以独立使用（带上你的向量），或与各种模块结合使用，对您的核心功能进行矢量化和增强。
- 多亏了其独特的设计，Weaviate确保了快速的性能和高效的操作。

## QuickStart:

要部署Weaviate，可以使用`docker-compose`。对于文本嵌入转换，我们将使用OpenAI模块：


```yaml
---
version: '3.4'
services:
  weaviate:
    image: semitechnologies/weaviate:1.20.0
    restart: on-failure:0
    ports:
     - "8080:8080"
    environment:
      QUERY_DEFAULTS_LIMIT: 20
      AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED: 'true'
      PERSISTENCE_DATA_PATH: "./data"
      DEFAULT_VECTORIZER_MODULE: text2vec-openai
      ENABLE_MODULES: text2vec-openai
      OPENAI_APIKEY: sk-xxx # replace with your OpenAI key
      CLUSTER_HOSTNAME: 'node1'
```

## 使用Weaviate和OpenAI

**1. 建立链接**
首先，我们建立与Weaviate向量数据库的连接：


```shell
pip install weaviate-client
```

```python
import weaviate

client = weaviate.Client(
        url = "http://localhost:8080"
)

client.is_live()
```

**2. 插入数据**
一旦与Weaviate向量数据库的连接正常，我们可以开始插入数据：

```python
uuid = client.data_object.create({
    'question': 'This vector DB is OSS & supports automatic property type inference on import',
    'somePropNotInTheSchema': 123,  # automatically added as a numeric property
}, 'JeopardyQuestion')

print(uuid)
```

**3. 查询数据**

使用Weaviate向量数据库检索数据同样简单：


```python
import json
data_object = client.data_object.get_by_id(
    '88e6d5e4-f31c-47f1-a7d9-cf0260e6a75e',
    class_name='JeopardyQuestion',
)

print(json.dumps(data_object, indent=2))
```

**4. 基本搜索操作**
最后，我们可以在Weaviate向量数据库中执行基本的搜索操作：

```python
response = (
    client.query
    .get("JeopardyQuestion", ["question"])
    .do()
)

print(response)
```

作为AI学习的重要组成部分，Weaviate是一个出色的向量数据库解决方案。其与OpenAI的无缝集成、速度和矢量化能力使其成为语义搜索操作的极佳选择。









