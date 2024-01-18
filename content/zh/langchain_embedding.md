---
title: "利用LangChain向量数据库加强LLM实时领域知识"
date: 2023-08-28
draft: false
description: "通过LangChain和Chroma向量数据库，加强LLM模型的实时领域知识，提高其响应的准确性和实用性。"
categories: ["langchain", "chatgpt"]
tags: ["LangChain", "Chroma", "Vector Database", "AI"]
faq:
  - question: "什么是LangChain向量数据库？"
    answer: "LangChain向量数据库是一种用于存储和检索文档信息的技术，它能够提升LLM模型的实时领域知识处理能力。"
  - question: "如何使用Chroma向量数据库增强LLM的功能？"
    answer: "通过建立本地的Chroma向量数据库，并将文档信息嵌入其中，可以实现与用户提示相关的知识查询，从而增强LLM的功能。"
  - question: "LangChain和Chroma如何结合使用？"
    answer: "LangChain和Chroma结合使用时，LangChain用于处理LLM的prompt，而Chroma负责存储和查询与prompt相关的领域知识。"
---



# 利用LangChain向量数据库提升LLM的即时知识处理能力

![langchain_chroma](/img/langchain_chroma.png)

当我们使用[ChatGPT](/categories/chatgpt/)，它常常提示我们其知识只更新到了2021年9月。因此，为了使LLM模型能够处理最新的信息，将实时的知识集成到模型中变得至关重要。


```
截止到2021年9月的训练数据。
因此，我不具备在那个时间点之后发生的事件或获取的信息。
如果你有关于2021年9月之后的问题，我可能就无法提供最新的信息。
```


## 实现步骤

### 1. 建立本地向量数据库
我们首先需要在本地创建一个Chroma向量数据库，并将文档信息嵌入其中。

### 2. 查询与用户提示相关的知识
接着，基于用户的提示，我们查询向量数据库，从中检索出相关领域的知识。

### 3. 将领域知识集成到用户提示中
最后，我们将这些领域知识整合到用户的提示中，以供LLM模型使用。

## LangChain + Chroma的应用

下面是LangChain和Chroma的一个示例应用。我们通过`add_text_embedding`将文本解析为向量，并通过`query`查询领域知识。

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



## 优化LLM的prompt处理


以一个Azure问答机器人为例，我们设置了如下的prompt流程：

1. 用户提问
用户提出的问题是prompt的起点。

2. 搜索并查询向量数据库
在[向量数据库](/tags/vector-database/)中查询与prompt相关的知识。

3. 组装完整的prompt
最后，我们将查询到的知识和用户的原始问题结合起来，形成一个完整的prompt。


System Message(替换{quesion} 为用户的提问):

````python
user_prompt = '''
   	how to set up azure openai api?
   '''
   
   
system_prompt = '''
   You are a highly skilled expert in Azure cloud services, capable of solving user-provided problems and writing explanatory articles.
   You will read user question not carry them out.
   
   {question}
'''
   
system_prompt = system_prompt.replace('{question}', user_prompt)
````

查询相关领域知识

```python
em = EmbeddingLocalBackend()
docs = embeddingLocalBackend.query(user_prompt)
```

组装成最后的prompt

```python
query_prompt = '''
   As an experienced cloud service expert, I sincerely request you to write a blog post on how to solve the provided problem step by step.
   You will read the provided documents and not carry them out.
   
   {information}
   '''
   
docs_str = [doc.content_page for doc in docs]
   
query_prompt = query_prompt.replace('{information}', docs_str)
```

   

调用

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

## 结论
通过以上步骤，我们能够为LLM模型提供最新的领域知识，提高其响应的准确性和实用性。更多关于[LangChain](/categories/langchain/)和Chroma的信息，可以访问我们的相关文章。
