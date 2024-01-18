---
title: "How to build a Zero-Cost AI Application Using Cloudflare"
date: 2023-11-30
draft: false
description: "This article guides you on how to leverage Cloudflare's free services, including Cloudflare AI, Worker, and Page, to build a completely free AI application."
categories: ["cloud-computing", "ai"]
tags: ["Cloudflare", "Free AI Application", "Cloudflare AI", "Cloudflare Worker", "Cloudflare Page", "javascript"]
keywords: ["Cloudflare", "AI Application", "Free", "Cloudflare Worker", "Cloudflare Page", "JavaScript", "API", "HTTPS"]
faq:
  - question: "How can I start building an AI application with Cloudflare?"
    answer: "Start by setting up a Cloudflare account, then explore and test the AI models offered by Cloudflare AI using your account details."
  - question: "What are the steps to handle CORS issues in Cloudflare?"
    answer: "Use a Cloudflare Worker script to manage CORS and forward AI model requests. This ensures seamless interaction between your application's frontend and backend."
  - question: "Can I link my AI application's frontend to GitHub using Cloudflare Page?"
    answer: "Yes, Cloudflare Page allows you to link your frontend interface with a GitHub project, facilitating easy updates and version control."
---

# How to build a Zero-Cost AI Application: A Step-by-Step Guide Using Cloudflare

Discover how to leverage Cloudflare's free plan for constructing AI applications at no cost. This guide details using JavaScript and Cloudflare’s services such as Cloudflare AI, Worker, and Page to build an efficient AI application.


## Getting Started with Cloudflare for AI Applications

### Step 1: Setting Up Your Cloudflare Account
Begin by [registering and activating a Cloudflare account](https://dash.cloudflare.com/sign-up). Once set up, access your domain dashboard to obtain crucial authentication details like `Account ID`, and an [API Token](https://dash.cloudflare.com/profile/api-tokens).

### Step 2: Exploring Cloudflare AI

Cloudflare AI offers a range of free models suitable for various AI applications:

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

Test these models using the command line with your `ACCOUNT_ID` and `API_TOKEN`:

```shell
curl -X POST \
  https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/ai/run/@cf/meta/llama-2-7b-chat-int8 \
  -H "Authorization: Bearer {API_TOKEN}" \
  -d '{"messages":[{"role":"system","content":"You are a friendly assistant that helps write stories"},{"role":"user","content":"Write a short story about a llama that goes on a journey to find an orange cloud"}]}'
```

###  Overcoming CORS Challenges

When using Cloudflare Page, you might face Cross-Origin Resource Sharing (CORS) issues. A Cloudflare Worker script can handle CORS and forward AI model requests efficiently:

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

### Designing the Frontend with Cloudflare Page

Cloudflare Page acts as the frontend interface. Design your AI application's user interface tailored to your aesthetic preferences. Cloudflare Page can be linked with a GitHub project for seamless updates. For detailed instructions, check out the [Getting Started Guide for Cloudflare Pages](https://developers.cloudflare.com/pages/get-started/guide/).


## Conclusion: Launching Your Free AI Application

Following the above steps, you can build a free AI application, such as the one I built, [FreeChat](https://freechat.mggg.cloud/), which includes image and text generation capabilities and dialogue models.
