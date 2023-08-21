---
title: "为Nginx设置免费的HTTPS证书（使用Let's Encrypt）"
date: 2023-08-07
draft: false
categories: ["free-series"]
tags: ["free", "https", "nginx", "let's encrypt"]
language: zh
---
## 简介

使用HTTPS保护网站不仅可以确保数据完整性，还可以增强用户信任和搜索引擎排名。通过Let's Encrypt，您可以轻松地为Nginx Web服务器获取免费的SSL/TLS证书。在本指南中，我们将为您介绍如何在CentOS上为Nginx服务器设置Let's Encrypt证书。
```shell
sudo yum install epel-release
sudo yum install certbot
```


## Step 2: 安装Certbot Nginx插件

为了简化获取和安装证书的过程，Certbot为Nginx提供了一个专用的插件。使用以下命令安装Certbot Nginx插件：

```shell
sudo yum install -y python3-certbot-nginx
```


## Step 3: 为Nginx生成证书

现在Certbot和Nginx插件已安装，可以生成SSL/TLS证书。请在下面的命令中将yourdomain.com替换为您的域名，然后运行它：
```shell
sudo certbot --nginx -d yourdomain.com
```
**warning:** 请记得替换您的域名


Certbot会进行交互，引导选择适当的选项并配置证书详细信息。



## Step 4: 自动Nginx配置

获得证书后，Certbot将自动修改Nginx配置以启用HTTPS访问。它将在nginx.conf文件中处理必要的更改，将HTTP流量重定向到安全的HTTPS协议。


## 总结

通过遵循这些简单的步骤，成功使用免费的Let's Encrypt SSL/TLS证书保护了Nginx Web服务器。现在，网站访问者可以享受安全的加密浏览体验，增强了他们对网站的信任，并提高了在搜索引擎结果中的可见性。

请定期更新Let's Encrypt证书，以确保持续保护网站安全。Certbot内置的自动更新功能可以让这一过程变得轻松无忧。