---
title: "Vector Database: Weaviate"
description: "Explore Weaviate, a scalable vector database designed for fast and accurate semantic search. Integrate it with OpenAI for text-to-embedding transformations."
date: 2023-07-07
tags: ["Weaviate", "Vector Database", "OpenAI", "Semantic Search", "AI Learning"]
categories: ["AI", "OPENAI"]
draft: false
faq:
  - question: "What is Weaviate?"
    answer: "Weaviate is a cloud-native, modular, real-time vector database built for scale. It integrates seamlessly with machine learning models, like OpenAI embeddings, to provide accurate semantic search capabilities."
  
  - question: "How does Weaviate integrate with OpenAI?"
    answer: "Weaviate integrates with OpenAI through its modules, enabling text-to-embedding transformations that are essential for semantic search and AI learning applications."

  - question: "Is there a tutorial for beginners to learn about vector databases?"
    answer: "Absolutely, beginners can refer to the [vector database tutorial](/tags/vector-database/) for a step-by-step guide on using Weaviate."
---


# Vector Database: Weaviate
Weaviate is an innovative vector database known for its efficiency in storing and retrieving data. Utilizing vectors, Weaviate indexes data objects based on their semantic properties, offering a unique approach to data handling. It supports a variety of modules, including `text2vec` and `OpenAI embeddings`, providing flexibility in data vectorization.

## Getting Started with Weaviate

Deploying Weaviate is straightforward with `docker-compose`. The OpenAI module transforms text into embeddings, enhancing semantic search capabilities.


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

## Integrating Weaviate with OpenAI
### 1. Setting Up the Connection

First, let's establish a connection to the Weaviate vector database using the `weaviate-client` Python library.



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

### 2. Inserting Data into Weaviate

With the connection established, inserting data into the Weaviate vector database is simple. Here, we demonstrate adding a data object.


```python
uuid = client.data_object.create({
    'question': 'This vector DB is OSS & supports automatic property type inference on import',
    'somePropNotInTheSchema': 123,  # automatically added as a numeric property
}, 'JeopardyQuestion')

print(uuid)
```

### 3. Retrieving Data


Retrieving data from Weaviate is just as straightforward, thanks to its efficient vector search capabilities.


```python
import json
data_object = client.data_object.get_by_id(
    '88e6d5e4-f31c-47f1-a7d9-cf0260e6a75e',
    class_name='JeopardyQuestion',
)

print(json.dumps(data_object, indent=2))
```

### 4. Executing Basic Searches

Performing basic search operations in Weaviate is efficient, making it ideal for applications like `mlb the show 22 database` and other complex datasets.


```python
response = (
    client.query
    .get("JeopardyQuestion", ["question"])
    .do()
)

print(response)
```

## Conclusion
Weaviate's harmonious integration with OpenAI, paired with its rapid vectorization capabilities, establishes it as an exceptional choice for semantic search operations across diverse projects, from a simple [python vector database](/tags/vector-database) to the multifaceted MLB The Show DB.












