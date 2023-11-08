---
title: "OpenAI 11.06更新"
date : "2023-11-08"
draft: false
description: "Explore the revolutionary updates from OpenAI's Python SDK 1.0.0, including multi-modal models, JSON mode responses, and system fingerprints, and how they can transform AI interactions."
categories: ["chatgpt", "OpenAI", "AI"]
tags: ["OpenAI", "AI", "GPT-4", "Python SDK", "Multi-Modal AI"]
keywords: ["OpenAI updates", "GPT-4 Vision", "chatgpt JSON mode", "chatgpt system fingerprint"]
---

## OpenAI 11.06更新

在这篇博客中，将讨论 OpenAI 11.06 的一些更新，更新主要有:
1. 聊天内容支持图片, ``gpt-4-vision-preview``
2. 返回内容支持json模式
3. 引入system_fingerprint， 支持可复现性

## OpenAI 多模态模型

OpenAI 引入的最令人兴奋的新功能之一是多模态模型，它可以处理文本和图像的组合。这一能力为 AI 应用打开了一个新的维度，从增强的视觉数据分析到更互动的聊天机器人。
### GPT-4 Vision: gpt-4-vision-preview
示例: 分析阿里巴巴股票的K线.

![alibaba](https://mggg.cloud/img/ali.png)

```python
import openai

openai.api_key = "your-api-key"

response = openai.ChatCompletion.create(
    model="gpt-4-vision-preview",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "What information can you understand from the K-line of the image?"},
                {
                    "type": "image_url",
                    "image_url": "https://mggg.cloud/img/ali.png",
                },
            ],
        }
    ],
    max_tokens=300,
)

print(response.choices[0].message.content)
```

## JSON模式
另一个值得注意的功能是 JSON 模式，它限制模型只生成有效的 JSON 输出。这对于需要将 AI 生成的内容集成到需要结构化数据的应用程序中的开发人员特别有用。


### 规范输出

假设您需要从给定输入中提取用户的姓名和年龄，并以 JSON 格式返回。有了新的 JSON 模式，这变成了一个简单的任务。

```python
response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo-1106",
    response_format={"type": "json_object"},
    messages=[
        {
            "role": "system",
            "content": [
                {"type": "text", "text": "extract name and age from user input, return a json object"},
            ],
        },
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "my name is wang and my age is 12, "},
            ],
        }
    ],
    max_tokens=300,
)

output = response.choices[0].message.content
import json

user_data = json.loads(output)
print(user_data)
```


## System Fingerprint

### 有唯一id追踪输出

随着 AI 模型不断更新，跟踪可能影响输出的变化的方法非常重要。OpenAI 的系统指纹功能通过为每个模型配置提供唯一标识符来解决这个问题。


```python
response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo-1106",
    response_format={"type": "json_object"},
    messages=[
        {
            "role": "system",
            "content": [
                {"type": "text", "text": "extract name and age from user input, return a json object"},
            ],
        },
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "my name is wang and my age is 12, "},
            ],
        }
    ],
    max_tokens=300,
)

print(response['system_fingerprint'])
```