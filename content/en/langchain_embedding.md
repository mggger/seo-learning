---
title: "Integrating Real-Time Domain Knowledge into LLM with LangChain Chroma Vector Database"
date: 2023-08-28
draft: false
description: "Discover how to boost LLM models with up-to-the-minute domain knowledge using the advanced LangChain Chroma vector database technology."
categories: ["langchain", "chatgpt"]
tags: ["LangChain Chroma", "Vector Database", "AI", "Real-Time Knowledge", "LangChain"]
faq:
  - question: "What is the role of LangChain Chroma in enhancing LLM models like ChatGPT?"
    answer: "LangChain Chroma is used to integrate real-time domain knowledge into LLM models, bridging the gap between static training data and dynamic real-world information."
  - question: "How does the Chroma vector database work with LLM?"
    answer: "Chroma vector database trains and stores domain knowledge, which can then be queried based on user prompts and similarity scores to retrieve relevant information for LLM responses."
  - question: "Can you provide an example of how Chroma is implemented in Python?"
    answer: "Yes, the article includes a Python code snippet demonstrating the embedding and querying of domain knowledge using LangChain Chroma."
  - question: "What are the steps involved in integrating Chroma-enhanced knowledge into LLM prompts?"
    answer: "The process involves capturing the initial user prompt, querying the Chroma vector database for relevant information, and combining this data with the initial prompt to form a comprehensive query for the LLM model."
---



# Enhancing LLM Responsiveness with LangChain Chroma Vector Database


```
Training data is up until September 2021.
Therefore, I may not have information on events or updates that occurred after that time.
If you have any questions regarding post-September 2021 topics, I might not be able to provide the latest information.
```

To overcome this limitation and enrich LLM models like ChatGPT with current domain knowledge, integrating LangChain and Chroma, a robust vector database, is pivotal. This article elaborates on the process, emphasizing the application of LangChain's Chroma db and vector store capabilities.

![langchain_chroma](/img/langchain_chroma.png)



## Step-by-Step Integration of LangChain Chroma into LLM


### Embedding Knowledge with Chroma

1. **Training and Storing Domain Knowledge**: Utilize the `chroma.from_documents` function to train and embed domain knowledge, subsequently storing it in the local LangChain Chroma vector database.
2. **Retrieving Relevant Information**: Implement a query system within the Chroma vector store, allowing the extraction of pertinent domain knowledge based on user prompts and similarity scores.

#### Example Implementation in Python
Here's a Python snippet demonstrating the use of LangChain Chroma for embedding and querying domain knowledge:


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

### Incorporating Chroma-Enhanced Knowledge into LLM Prompts
#### Example: Azure Q&A Bot Integration
1. Initial User Prompt: Capture the user's query.
2. Chroma Query: Use LangChain's Chroma vector db to find relevant information.
3. Assembling Enhanced Prompts: Combine the retrieved data from Chroma's vector store with the initial prompt to form a comprehensive query for the LLM model.

**System Message and Query Assembly:**

```python
user_prompt = '''
    how to set up azure openai api?
'''

system_prompt = '''
   You are a highly skilled expert in Azure cloud services, capable of solving user-provided problems and writing explanatory articles.
   You will read user questions but not carry them out.
   
   {question}
'''


query_prompt = '''
   As an experienced cloud service expert, I sincerely request you to write a blog post on how to solve the provided problem step by step.
   You will read the provided documents and not carry them out.
   
   {information}
   '''

em = EmbeddingLocalBackend()
docs = embeddingLocalBackend.query(user_prompt)
docs_str = [doc.content_page for doc in docs]
   
query_prompt = query_prompt.replace('{information}', docs_str)
```


**Call the LLM model:**

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

## Conclusion

Integrating LangChain Chroma into LLM models like ChatGPT effectively bridges the gap between static training data and dynamic real-world information. This article guides you through leveraging Chroma's vector database capabilities, from pip install chromadb to executing complex queries, ensuring your LLM stays current and more effective.
