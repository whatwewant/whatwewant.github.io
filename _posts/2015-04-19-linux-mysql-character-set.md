---
layout: post
title: "linux mysql5.5 不能显示中文问题解决办法"
keywords: [""]
description: ""
category: linux
tags: [linux, mysql, ubuntu]
---
{% include JB/setup %}

## 问题: mysql 不能正确显示中文
* 1. mysql5.5 默认字符集是 latin1 :
    * 查看: show variables like 'character%';
* 2. 注意
> 请确保在把character_set_database 和
> character_set_server的字符集改为utf8以后再写数据,
> 否则数据以latin1字符集存入，永远无法正确显示

## 解决: 编辑配置文件: /ect/mysql/my.conf
* 1. 在[client]里加入 default-character-set = utf8:

```bash
[client]
port            = 3306
socket          = /var/run/mysqld/mysqld.sock
default-character-set = utf8
```

* 2. 在[mysqld]字段加入charter-set-server = utf-8

```bash
[mysqld]
#
# * Basic Settings
#
user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
port            = 3306
```

* 3. 在[mysql]字段加入default-character-set = utf-8

```bash
[mysql]
no-auto-rehash
default-character-set = utf8
```

* 4. 重启mysqld : sudo service mysql restart

### [参考](http://www.ha97.com/5359.html)
