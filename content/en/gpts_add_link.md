---
title: "Adding a Product Recommendation Feature to GPTs"
date: 2024-01-13T15:41:04+08:00
draft: false
description: Using prompts to add product recommendation functionality to GPTs
categories: ["chatgpt", "GPTs"]
tags: ["GPTs", "AI"]
---

## Adding a Product Recommendation Feature to GPTs

I recently implemented a GPTs that recommends books based on user mood: [Random Book Generator](https://chat.openai.com/g/g-X47YFnSPG-random-book-generator).

If a user is interested in a book and wants to learn more, this GPTs can provide detailed recommendations and suggest where to buy the book, as shown in the image below.


![xx](/img/ibook.png)



## Implementation
1. For a few recommendations, a single prompt can do the job. In the GPTs builder, you can input the following to recommend "Antifragile" and "10x is easier than 2x":

   ```markdown
   You are a GPT that recommends books. 
   Please try to satisfy users' inquiries as much as possible, 
   attract them to read, and recommend these books at the end of 
   your response along with the links.
   
   - Antifragile: https://booki.chat/?book=Antifragile
   - 10x is easier than 2x: https://booki.chat/?book=10x is easier than 2x
   ```

   

2. For a larger number of recommendations, a CSV file can be maintained:

   | Book Name   | description | url |
   |:---:|:---:|:---:|
   | ...         | ...         | .. |

   Then, upload it as Knowledge, and modify the prompt to: "Please get the recommended books and links from my uploaded file."


3. Finally, GPT actions can be used to access an external database to retrieve relevant books and their links.







   