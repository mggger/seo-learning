---
title: "Building a Zero-Cost AI Application Using Cloudflare"
date: 2023-11-30
draft: false
description: "This article guides you on how to leverage Cloudflare's free services, including Cloudflare AI, Worker, and Page, to build a completely free AI application."
categories: ["cloud-computing", "ai"]
tags: ["Cloudflare", "Free AI Application", "Cloudflare AI", "Cloudflare Worker", "Cloudflare Page", "javascript"]
keywords: ["Cloudflare", "AI Application", "Free", "Cloudflare Worker", "Cloudflare Page", "JavaScript", "API", "HTTPS"]

---

# Building a Zero-Cost AI Application: Leveraging the Power of Cloudflare

In the current tech landscape, using Cloudflare's free plan allows for the easy construction of zero-cost AI applications. This article will guide you on how to achieve this solely by using JavaScript and a few key services of Cloudflare—Cloudflare AI, Cloudflare Worker, and Cloudflare Page. Here, Cloudflare Worker acts as the backend service, while Cloudflare Page serves as the frontend.

## Preliminary Steps

To start this project, you first need to:

1. Register and activate a Cloudflare account.
2. Obtain necessary authentication information from your domain dashboard, including `Account ID`, and [API Token](https://dash.cloudflare.com/profile/api-tokens).

## Cloudflare AI

Cloudflare AI currently supports a variety of models for free:

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

You can quickly test these models with the following command line example, combined with the previously obtained `ACCOUNT_ID` and `API_TOKEN`:

```shell
curl -X POST \
  https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/ai/run/@cf/meta/llama-2-7b-chat-int8 \
  -H "Authorization: Bearer {API_TOKEN}" \
  -d '{"messages":[{"role":"system","content":"You are a friendly assistant that helps write stories"},{"role":"user","content":"Write a short story about a llama that goes on a journey to find an orange cloud"}]}'
```

## Cloudflare Worker: Handling CORS

Since using Cloudflare Page might encounter Cross-Origin Resource Sharing (CORS) issues, you can resolve this by building a service through Cloudflare Worker, instead of directly calling the Cloudflare AI API. Below is a basic Cloudflare Worker script for handling CORS and forwarding AI model requests:

```js
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

// The main request handling function
async function handleRequest(request) {

  // Handle CORS preflight requests
  if (request.method === "OPTIONS") {
    return handleCors();
  }

  return handleChatGPTRequest(request);
}

// Function to handle CORS preflight requests
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

1. Upload this script to your Cloudflare Worker.
2. Configure `ACCOUNT_ID` and `BEARER_TOKEN` in the Worker settings (Settings -> Variables).
3. Test your Worker: click Quick Edit, and directly use Cloudflare's built-in functionality for testing.

![cloud](/img/cloudflare.png)

## Cloudflare Page: Frontend Interface

Cloudflare Page, serving as the frontend, is responsible for page construction and user interaction. You can design the AI application interface according to your personal aesthetics, and it can be directly linked with a GitHub project. For more information, please refer to the [Getting Started Guide for Cloudflare Pages](https://developers.cloudflare.com/pages/get-started/guide/).

## Conclusion

Following the above steps, you can build a free AI application, such as the one I built, [FreeChat](https://freechat.mggg.cloud/), which includes image and text generation capabilities and dialogue models.
