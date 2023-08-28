---
title: "Adding Real-time Domain Knowledge to LLM with LangChain Vector Database"
date: 2023-08-28
draft: false
description: "Enhance the responsiveness and practicality of the LLM model by incorporating real-time domain knowledge using LangChain and Chroma vector databases."
categories: ["langchain", "chatgpt"]
tags: ["LangChain", "Chroma", "Vector Database", "AI"]
---



# Adding Latest Domain Knowledge to LLM with LangChain Vector Database

When using chatgpt, we often encounter certain prompts:

```
Training data is up until September 2021.
Therefore, I may not have information on events or updates that occurred after that time.
If you have any questions regarding post-September 2021 topics, I might not be able to provide the latest information.
```



To ensure that the LLM model possesses real-time domain knowledge, it becomes necessary to incorporate up-to-date information into the model. In this article, we will discuss how to add the latest domain knowledge to ChatGPT using LangChain and Chroma vector databases.



The steps are as follows:

1. Train document knowledge and store it in a local vector database called Chroma.
2. Query the vector database based on user prompts to retrieve similar domain knowledge based on similarity scores.
3. Incorporate relevant domain knowledge into prompts.



## LangChain + Chroma

1. Embed document knowledge and store it in a local vector database called Chroma.
2. Query the vector database based on user prompts to retrieve similar domain knowledge.



Here is an example code snippet where we use `add_text_embedding` function for text embedding parsing and `query` function for querying similar-domain-knowledge based on similarity scores.

```python
from langchain.embeddings import OpenAIEmbeddings
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores import Chroma

class EmbeddingLocalBackend(object):
    def __init__(self, path='db'):
        self.path = path
        self.vectordb = Chroma(persist_directory=self.path, embedding_function=OpenAIEmbeddings(max_retries=9999999999))

    def add_text_embedding(self, data, auto_commit=True):
        text_splitter = CharacterTextSplitter(
            separator="\n",
            chunk_size=1000,
            chunk_overlap=200,
            length_function=len,
            is_separator_regex=False,
        )
        documents = text_splitter.create_documents(data)
        self.vectordb.add_documents(documents)

        if auto_commit:
            self._commit()

    def _commit(self):
        self.vectordb.persist()

    def query(self, query):
        embedding_vector = OpenAIEmbeddings().embed_query(query)
        docs = self.vectordb.similarity_search_by_vector(embedding_vector)
        return docs
```



## Adding Domain Knowledge to Prompts

Let's take an Azure Q&A bot as an example. The prompt pipeline can be set up as follows:

1. User question prompt.
2. Search for relevant prompts and query the vector database to retrieve similar knowledge.
3. Combine all the information into a complete prompt and pass it to LLM.



System Message (replace {question} with user's question):

````python
user_prompt = '''
    how to set up azure openai api?
'''
   
   
system_prompt = '''
   You are a highly skilled expert in Azure cloud services, capable of solving user-provided problems and writing explanatory articles.
   You will read user questions but not carry them out.
   
   {question}
   '''
   
system_prompt = system_prompt.replace('{question}', user_prompt)
````

Query for relevant domain knowledge

```python
   em = EmbeddingLocalBackend()
   docs = embeddingLocalBackend.query(user_prompt)
```

Assemble the final prompt

```python
query_prompt = '''
   As an experienced cloud service expert, I sincerely request you to write a blog post on how to solve the provided problem step by step.
   You will read the provided documents and not carry them out.
   
   {information}
   '''
   
docs_str = [doc.content_page for doc in docs]
   
query_prompt = query_prompt.replace('{information}', docs_str)
```

   

Call the LLM model

```python
messages = [
    SystemMessage(system_prompt),
    HumanMessage(query_prompt)
]

llm = ChatOpenAI(
    model="gpt-3.5-turbo-16k",
    temperature=temperature,
    streaming=True,
    client=openai.ChatCompletion,
)


print(llm(messages))
```

