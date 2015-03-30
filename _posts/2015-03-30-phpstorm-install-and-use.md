---
layout: post
categorate: php
tags: [linux, php, tools]
---

## Ubuntu14.04 下 PHPStorm 的安装与使用

## 1. 下载安装包: 
* 官网: https://www.jetbrains.com/phpstorm/
* Version: 8.0.3
* Tar.gz address: http://120.192.76.118/cache/download.jetbrains.com/webide/PhpStorm-8.0.3.tar.gz?ich_args=9fd2851c9cfc749a6559bc79da0a2afd_1_0_0_2_9f03a674e5a343c018824d475fe8fee3f0d70d2696fcc53137cc8baa4a1bdc88_cc554e7620bff0a435beff2603e2ee3d_1_0

## 2. 解压并使用
* tar -xcf PhpStorm-8.0.3.tar
* cd PhpStorm-8.0.3
* ./phpstorm.sh

## 3. php server
* sudo apt-get install php5 php5-fpm php5-cgi

## 4. 配置phpstorm php server
* -> File -> Settings -> Languages & Frameworks
    -> PHP -> Servers -> +（绿色+号添加新服务器）
    -> Name: phpserver
    -> Host: localhost 或者 127.0.0.1
    -> Port: 9090
    -> Debugger: Xdebug
    
## 5. OK, 现在可以写完代码然后直接在浏览器执行了！