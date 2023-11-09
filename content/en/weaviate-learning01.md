---
title: "Vector Database: Weaviate"
description: "Explore Weaviate, a scalable vector database designed for fast and accurate semantic search. Integrate it with OpenAI for text-to-embedding transformations."
date: 2023-07-07
keywords: ["Weaviate", "Vector Database", "OpenAI", "Semantic Search", "AI Learning"]
categories: ["ai-learning"]
draft: false
---

# Vector Database: Weaviate

Weaviate is an innovative vector database that offers powerful features for data storage and retrieval.
- By using vectors to index data objects, Weaviate can store and retrieve data objects based on their semantic properties.
- Weaviate can be used independently (bring your vectors) or in conjunction with various modules that vectorize and enhance core functionalities for you.
- Thanks to its unique design, Weaviate ensures fast performance and efficient operations.

## QuickStart:

To deploy Weaviate, you can use `docker-compose`. For text-to-embedding transformations, we'll utilize the OpenAI module:

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

## Working with Weaviate and OpenAI
**1. Establishing a Connection**
First, we establish a connection to the Weaviate vector database:

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

**2. Inserting Data**
Once the connection to the Weaviate vector database is live, we can start inserting data:
```python
uuid = client.data_object.create({
    'question': 'This vector DB is OSS & supports automatic property type inference on import',
    'somePropNotInTheSchema': 123,  # automatically added as a numeric property
}, 'JeopardyQuestion')

print(uuid)
```

**3. Querying Data**

Data retrieval is just as easy with the Weaviate vector database:
```python
import json
data_object = client.data_object.get_by_id(
    '88e6d5e4-f31c-47f1-a7d9-cf0260e6a75e',
    class_name='JeopardyQuestion',
)

print(json.dumps(data_object, indent=2))
```

**4. Basic Search Operations**
Lastly, we can carry out basic search operations in the Weaviate vector database:
```python
response = (
    client.query
    .get("JeopardyQuestion", ["question"])
    .do()
)

print(response)
```

As an integral part of AI learning, Weaviate stands out as a remarkable vector database solution. Its seamless integration with OpenAI, speed, and vectorization capabilities make it an excellent choice for semantic search operations.









