---
title: "给GPTs添加带货功能"
date: 2024-01-13T15:41:04+08:00
draft: false
description: 通过promtp，来给GPTs添加带货功能
categories: ["chatgpt", "GPTs"]
tags: ["GPTs", "AI"]
toc: true
---

## 给GPTs添加带货功能

最近实现了一个根据用户心境，来推荐相应书籍的GPTs:  [Random Book Generator](https://chat.openai.com/g/g-X47YFnSPG-random-book-generator) 

如果用户对这本书感兴趣，想了解更多的话， 这个GPTs就可以进行详情推荐，向用户推荐这本书可以在哪里购买, 如下图所示

![xx](/img/ibook.png)



## 实现

1. 如果推荐不是很多，一句prompt就可以搞定,   在GPTs builder里面输入: 以下是推荐<<反脆弱>> 和<<10x is easier than 2x>>两本书示例:

   ```markdown
   You are a GPT that recommends books. 
   Please try to satisfy users' inquiries as much as possible, 
   attract them to read, and recommend these books at the end of 
   your response along with the links.
   
   - Antifragile: https://booki.chat/?book=Antifragile
   - 10x is easier than 2x: https://booki.chat/?book=10x is easier than 2x
   ```

   

2. 如果推荐很多的话， 可以使用一张csv来维护

   
   | Book Name   | description | url |
   |:---:|:---:|:---:|
   | ...         | ...         | .. |

   然后将其上传为Knowledge,   prompt修改为:  请从我的上传的文件里面获取推荐书籍和链接



3. 最后呢也可以通过gpt action访问外部数据库来获取相关书籍以及链接

   