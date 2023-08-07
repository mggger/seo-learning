---
title: "Setting Up Free HTTPS Certificates for Nginx using Let's Encrypt"
date: 2023-08-07
draft: false
categories: ["free-series"]
tags: ["free", "https", "nginx", "let's encrypt"]
---
## Introduction

Securing your website with HTTPS not only ensures data integrity but also boosts user trust and search engine rankings. With Let's Encrypt, you can obtain free SSL/TLS certificates for your Nginx web server effortlessly. In this guide, we'll walk you through the process of setting up a Let's Encrypt certificate for your Nginx server on CentOS.
```shell
sudo yum install epel-release
sudo yum install certbot
```


## Step 2: Installing the Certbot Nginx Plugin

To simplify the process of obtaining and installing certificates, Certbot offers a dedicated plugin for Nginx. Install the Certbot Nginx plugin using the following command:

```shell
sudo yum install -y python3-certbot-nginx
```


## Step 3: Generating Certificates for Nginx

Now that Certbot and the Nginx plugin are installed, you can generate your SSL/TLS certificates. Replace `mggg.cloud` with your domain name in the command below and run it:
```shell
sudo certbot --nginx -d yourdomain.com
```
**warning:** please remember replace your domain


Certbot will interactively guide you through the process, prompting you to choose the appropriate options and configure the certificate details.

## Step 4: Automatic Nginx Configuration

Once you've obtained the certificate, Certbot will automatically modify your Nginx configuration to enable HTTPS access. It will handle the necessary changes in your `nginx.conf` file, redirecting HTTP traffic to the secure HTTPS protocol.

## Conclusion

By following these simple steps, you've successfully secured your Nginx web server with a free Let's Encrypt SSL/TLS certificate. Your website visitors can now enjoy a safe and encrypted browsing experience, bolstering both their trust in your site and its visibility in search engine results.

Remember to periodically renew your Let's Encrypt certificates to ensure continuous security for your website. Automated renewal can be set up with Certbot's built-in functionality, making the process hassle-free.

In conclusion, Let's Encrypt provides an accessible and no-cost solution to enhance your website's security with HTTPS encryption. By leveraging the power of Let's Encrypt and Nginx, you're actively contributing to a safer and more secure internet for everyone.


