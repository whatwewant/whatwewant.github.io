---
layout: post
title: Ubuntu Server 配置 LAMP
category: php
tags: [php, server, lamp]
---
{% include JB/setup %}

## 1. Environment
* 1. Ubuntu 14.10 Server
* 2. LAMP = Linux + Apache + Mysql/MariaDB + PHP

## 2. INSTALLATION
* 1. Apache:
    * sudo apt-get install apache2
    * 查看版本: apache2 -v
* 2. Php :
    * sudo apt-get install php5
    * 查看是否被加载: cat /etc/apache2/mods-enabled/php5.load 证明被加载
    * 查看版本: php5 -v
* 3. Mysql:
    * sudo apt-get install mysql-server
    * 查看mysql是否被php加载: cat /etc/php5/conf.d/mysql.ini :
    * 查看mysql是否被php加载 或者: cat /etc/php5//mods-available/mysql.ini :
        * php默认没有mysql扩展，为了加载 mysql.so : sudo apt-get install php5-mysql

```bash
软件总结: sudo apt-get install apache2 php5 mysql php5-mysql
更简单的方法: `sudo tasksel install lamp-server`
```

* `注意: tasksel 提供 LAMP / DNS server / Mail server .. 的安装`

## 3. Make sure them work correctly.
* 1. sudo service mysql restart
* 2. sudo service apache2 restart

## 4. 创建phpinfo服务器探针
* 1. cd /var/www/html
* 2. sudo vim info.php

```php
<?php
echo mysql_connect('localhost', 'root', 'root') ? 'It works.' : 'It doesn\'t work';

phpinfo();
```
* 3. 检查是否成功: 访问 http://服务器IP/info.php

## 5. 给PHP添加常用扩展
* 1. php5-gd curl libcurl3 libcurl3-dev php5-curl :
    * sudo apt-get install php5-gd curl libcurl3 libcurl3-dev php5-curl
    * 1. gd :
    * 2. curl :
* 2. 重启服务，使模块生效:sudo service apache2 restart
* 3. 查看模块是否生效:
    1. 查看: cat /etc/php5/mods-available/...
    2. 或者 浏览器访问: http://服务器IP/info.php, 搜索 gd, curl
* 4. sftp 命令
* 5. vsftpd ---- FTP 服务器 
* 6. 或者用 FileZilla 配置客户端

## 6. LAMP环境文件目录概述
* 1. Linux系统配置文件目录: /etc :
    * Apache : /ect/apache2
    * mysql : /etc/mysql
    * php : /etc/php5
* 2. Apache2 配置 (/ect/apache2):
    * 1. 加载流程: 
        * 1. 首先加载 apache2.conf
        * 2. 然后在apache2.conf 通过Include 加载其他文件/模块:
            * 1. conf-enabled/\*
            * 2. httpd.conf
            * 3. ports.conf
            * 4. mods-enabled/\*
            * 5. sites-enabled/\*
    * 2. 核心配置:
        * 1. mods-\*\*\* Apache模块
        * 2. sites-\*\*\* 虚拟主机
    * 3. 关键字:
        * 1. available 可用; enabled 已经启用.
        * 2. (创建需要启用的mod, 软连接available到enabled) :
            * enabled ----> available: ln -s 命令 建立软连接
* 3. Mysql 配置 (/etc/Mysql/my.conf):
    * 1. 
* 4. Php 配置 (/etc/php5/apache2/php.ini)
