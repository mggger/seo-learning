---
title: "How to Build a Zero-Cost AI Application Using Cloudflare"
date: 2023-11-30
draft: false
description: "Learn to harness Cloudflare's complimentary offerings, such as AI Workers and Cloudflare Pages, to develop a cost-free AI application with powerful AI GPU capabilities."
categories: ["cloud-computing", "ai"]
tags: ["Cloudflare", "Free AI Application", "Cloudflare AI", "Cloudflare Worker", "Cloudflare Page", "javascript"]
keywords: ["Cloudflare", "AI Application", "Free", "Cloudflare Worker", "Cloudflare Page", "JavaScript", "API", "HTTPS", "AI GPU", "Chat GPU", "Run AI", "AI Inference", "GPU AI", "GPU and AI", "Inference AI", "Serverless GPU", "Cloudflare AI", "Cloudflare AI Workers", "Free GPU", "Get Inference AI Radar", "AI Worker", "Full Throttle AI", "GPU Pricing", "Huggingface Pricing", "Meta AI Blog", "Powered Models", "AI Running", "Cloudflare Workers AI", "Inferential中文", "Run.ai", "Nvidia Flare", "What is Inference in AI", "AI and GPU", "AI Neuron", "AI Workers", "Nvidia Workers", "NvidiaAI", "AI GPUs", "AI Inferences", "AI Staff", "Chat GPU AI", "GPU Machine", "Inferences中文", "Workers AI", "Cloudflare Worker Price", "CUDA GPT", "Edge GPU", "Hosted GPU", "Running AI", "Serverless Machine Learning", "What is AI Inferencing", "Cloud Inference", "GBT Zero AI", "Get Inference AI", "GPU Locations", "How the World Runs and Your Part in It", "Inference Service", "Inferencing AI", "Serverless GPUs", "Serverless Inference", "Zero Work .ai"]
faq:
  - question: "How can I start building an AI application with Cloudflare?"
    answer: "Start by setting up a Cloudflare account, then explore and test the AI models offered by Cloudflare AI using your account details."
  - question: "What are the steps to handle CORS issues in Cloudflare?"
    answer: "Use a Cloudflare Worker script to manage CORS and forward AI model requests. This ensures seamless interaction between your application's frontend and backend."
  - question: "Can I link my AI application's frontend to GitHub using Cloudflare Page?"
    answer: "Yes, Cloudflare Page allows you to link your frontend interface with a GitHub project, facilitating easy updates and version control."
---


# How to Build a Zero-Cost AI Application: A Step-by-Step Guide Using Cloudflare

Harness the power of Cloudflare's free tier to construct AI applications without incurring costs. This guide delineates the process of employing JavaScript along with Cloudflare's suite of services—including AI inference engines and Cloudflare Workers—to craft a robust, serverless AI application.

![cloudflare_ai](/img/cloudflare_ai.png)

## Step-by-Step Configuration for AI Deployment on Cloudflare


### Step 1: Initiate with Cloudflare Account Configuration

Kickstart your journey by [setting up your Cloudflare account](https://dash.cloudflare.com/sign-up). Post setup, navigate through your domain's dashboard to retrieve essential credentials such as `Account ID`, and secure an [API Token](https://dash.cloudflare.com/profile/api-tokens) for your AI inferences.


### Step 2: Tap into Cloudflare AI's Potential

Embrace the diverse, free models that Cloudflare AI presents, catering to a variety of GPU AI tasks and inference AI needs:

**List of AI models:**

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

Deploy these models using your terminal, substituting `ACCOUNT_ID` and `API_TOKEN` with your specific details:


```shell
curl -X POST \
  https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/ai/run/@cf/meta/llama-2-7b-chat-int8 \
  -H "Authorization: Bearer {API_TOKEN}" \
  -d '{"messages":[{"role":"system","content":"You are a friendly assistant that helps write stories"},{"role":"user","content":"Write a short story about a llama that goes on a journey to find an orange cloud"}]}'
```

###  Step 3: Navigate CORS with Cloudflare Workers


To mitigate CORS issues when using Cloudflare Page, deploy a Cloudflare Worker script to orchestrate CORS and relay AI model queries effectively:



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

- Upload the script to your Cloudflare Worker.
- Amend `ACCOUNT_ID` and `BEARER_TOKEN` within your Worker's configurations.
- Validate your Worker: utilize Cloudflare's test feature for immediate results.


![cloud](/img/cloudflare.png)

### Step 4: Designing Your AI Interface with Cloudflare Page


Utilize Cloudflare Page to construct the frontend. Integrate it with GitHub to streamline updates and manage your AI application's interface, which is now ready to perform tasks like AI running, inference, and chat GPU operations.




## Wrapping Up: Deploy Your Serverless GPU AI Application
By adhering to the aforementioned steps, your cost-free AI application, akin to [FreeChat](https://freechat.mggg.cloud/)—equipped with image and text generation, along with dialogue models—is ready to go full throttle on AI. With Cloudflare's AI neuron at its core, your app can now perform at the edge of technological advancement, all the while being kind to your budget.
