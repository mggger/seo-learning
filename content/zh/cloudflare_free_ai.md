---
title: "使用Cloudflare构建0成本的AI应用"
date: 2023-11-30
draft: false
description: "本文指导您如何利用Cloudflare的免费服务，包括Cloudflare AI, Worker, 和 Page，来构建一个完全免费的AI应用。"
categories: ["cloud-computing", "ai"]
tags: ["Cloudflare", "免费AI应用", "Cloudflare AI", "Cloudflare Worker", "Cloudflare Page", "javascript"]
keywords: ["Cloudflare", "AI应用", "免费", "Cloudflare Worker", "Cloudflare Page", "JavaScript", "API", "HTTPS"]
toc: true
---



# 构建0成本的AI应用：利用Cloudflare的强大功能

在当前的技术环境中，利用Cloudflare的免费套餐（Free Plan）可以轻松构建零成本的AI应用。仅通过使用JavaScript和Cloudflare的几个关键服务——Cloudflare AI, Cloudflare Worker, 和 Cloudflare Page——来实现这一目标。其中，Cloudflare Worker充当后端服务，而Cloudflare Page则扮演前端的角色。



## 初步准备

要开始这个项目，首先需要：

1. 注册并开通Cloudflare账户。
2. 从域名dashboard页面获取必要的认证信息，包括`Account ID` , 和[API Token](https://dash.cloudflare.com/profile/api-tokens)



## Cloudflare AI

Cloudflare AI目前免费支持多种模型

- @cf/baai/bge-base-en-v1.5
- @cf/baai/bge-large-en-v1.5
- @cf/baai/bge-small-en-v1.5
- @cf/huggingface/distilbert-sst-2-int8
- @cf/meta/llama-2-7b-chat-fp16
- @cf/meta/llama-2-7b-chat-int8
- @cf/meta/m2m100-1.2b
- @cf/microsoft/resnet-50
- @cf/mistral/mistral-7b-instruct-v0.1
- @cf/openai/whisper
- @cf/stabilityai/stable-diffusion-xl-base-1.0



可以通过以下命令行示例，结合前面获取的`ACCOUNT_ID`和`API_TOKEN`，快速测试这些模型：

```shell
curl -X POST \
  https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/ai/run/@cf/meta/llama-2-7b-chat-int8 \
  -H "Authorization: Bearer {API_TOKEN}" \
  -d '{"messages":[{"role":"system","content":"You are a friendly assistant that helps write stories"},{"role":"user","content":"Write a short story about a llama that goes on a journey to find an orange cloud"}]}'
```



## Cloudflare Worker: 处理CORS

由于在使用Cloudflare Page时可能会遇到跨源资源共享（CORS）问题，因此可以通过Cloudflare Worker构建服务来解决这个问题，而不是直接调用Cloudflare AI的API。以下是一个基本的Cloudflare Worker脚本，用于处理CORS和转发AI模型请求：

```js
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

// 主要的请求处理函数
async function handleRequest(request) {

  // 处理 CORS 预检请求
  if (request.method === "OPTIONS") {
    return handleCors();
  }

  return handleChatGPTRequest(request);
}


// 处理 CORS 预检请求的函数
function handleCors() {
  return new Response(null, {
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    }
  });
}

async function handleChatGPTRequest(request) {
  const url = `https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/ai/run/@cf/meta/llama-2-7b-chat-int8`;

  const headers = {
    "Authorization": `Bearer ${BEARER_TOKEN}`,
    "Content-Type": "application/json"
  };

  const newRequest = new Request(url, {
    method: "POST",
    headers: headers,
    body: request.body
  });

  const response = await fetch(newRequest);
  const newResponse = new Response(response.body, response);
  newResponse.headers.set("Access-Control-Allow-Origin", "*");

  return newResponse;
}
```

1. 将此脚本上传到Cloudflare Worker。
2. 在Worker设置中（Settings -> Variables），配置`ACCOUNT_ID`和`BEARER_TOKEN`。
3. 测试Worker：点击Quick Edit，直接利用Cloudflare的内置功能进行测试。

![clodu](/img/cloudflare.png)


## Cloudflare Page：前端界面

Cloudflare Page作为前端，负责页面构建和用户交互。你可以根据个人审美设计AI应用界面，并且可以将其与GitHub项目直接关联。更多信息请参考 [Cloudflare Pages入门指南](https://developers.cloudflare.com/pages/get-started/guide/)。



## 总结

通过以上步骤，您可以构建一个免费的AI应用，例如我构建的 [FreeChat](https://freechat.mggg.cloud/)，它包含图文生成功能和对话模型。







