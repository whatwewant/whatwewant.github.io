---
layout: post
title: "apache2.4: You don't have permission to access / on this server."
keywords: ""
description: ""
category: php
tags: [linux, php, apache2]
---
{% include JB/setup %}

## 1. 檢查權限
* 1. 用戶和組的配置:
>   sudo vim /etc/apache2/apache2.conf 找到 User 和 Group
> 发现配置用户和组的文件在/etc/apache2/envvars
>    1. 第一种强制方法就是将User ${APACHE_RUN_USER}改为 User ubuntu, 将Group ${APACHE_RUN_GROUP}改为Group ubuntu (其中ubuntu是web根目录(DocumentRoot)权限用户)
>    2. 第二种方法是修改/etc/apache2/envvars
>      将export APACHE_RUN_USER=www-data改为export APACHE_RUN_USER=ubuntu
>      将export APACHE_RUN_GROUP=www-data改为export APACHE_RUN_GROUP=ubuntu (其中ubuntu为web根目录(DocumentRoot)权限用户)

* 2. 修改web根目录权限, 默认是当前用户:
    * sudo chown -R owner:group /path/to/webDocumentRootDirectory

* 3. 默认启动/etc/apache2/sites-enabled/\*.conf, 因为/etc/apache2/apache2.conf中IncludeOptional sites-enabled/\*.conf

* 4. 默认启动的virtual host是/etc/apache2/sites-enabled/000-default.conf, 修改DocumentRoot:
    * DocumentRoot /path/to/webDocumentRootDirectory

* 5. Directory是配置文件，这个不明白; DocumentRoot是virtual host的web文件根目录
