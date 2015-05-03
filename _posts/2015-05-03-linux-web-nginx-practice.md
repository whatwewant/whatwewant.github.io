---
layout: post
title: "linux web nginx practice"
description: Linux Web Nginx 实践
category: linux
tags: [linux, nginx, web, lnmp]
---
{% include JB/setup %}

## 参考
* [实验室](https://www.shiyanlou.com/courses/95)
* [官网](http://nginx.org/)

## 安装 nginx (ubuntu)
* 方法一: sudo apt-get install nginx
* 方法二: [脚本]({{site.url}}/scripts/install_nginx.sh)
* `以下配置根据方法一`

## NGINX实践: LNMP
* 1. nginx
    * 安装: sudo apt-get install nginx
    * 启动: sudo service nginx start 或 sudo /etc/init.d/nginx start
    * 停止: sudo service nginx stop
    * 重载配置: sudo service nginx reload
    * 重启: sudo service nginx restart
    * 检测配置是否正确: sudo nginx -t
    * 配置文件: /etc/nginx/conf/nginx.conf 
    * 默认server: /etc/nginx/sites-available/default
    * 浏览器访问: http://127.0.0.1

* 2. mysql
    * 安装: sudo apt-get install mysql-server mysql-client
    * 配置文件: /etc/mysql/my.cnf
    * `注意: 配置文件将bind-address = 127.0.0.1 注释掉，就可以远程连接数据库了`
    * 启动/停止/重新启动: sudo service mysql start/stop/restart

* 3. php5
    * 在LNMP中的作用或角色:
        >   nginx 本身不能处理PHP, 他只是个web服务器, 当接收到请求后,
        > 如果是php请求, 则发个php解释器处理，并把结果返回给客户端.
        > php-fpm 是一个守护进程(FastCGI进程管理器)用于替换PHP FastCGI的
        > 大部分附加功能, 对于高负载网站是非常有用的
    * 安装: sudo apt-get install php5-fpm
    * 安装好后连同上面的nginx一同测试:
        >   现在创建一个探针文件保存在 /usr/share/nginx/html 目录下
        > (这个目录是nginx配置文件中的root目录).
        > 新php文件: sudo vim /usr/share/nginx/html/phpinfo.php
        > 添加代码: <? php phpinfo();
    * 启动php5-fpm服务: sudo service php5-fpm start
    * 访问浏览器: http://127.0.0.1/phpinfo.php

* 4. 组合配置, 互相支持:
    * 1. 让php5支持mysql:
        * 安装: sudo apt-get install php5-mysql
        * 重启php: sudo service php5-fpm restart
        * 访问浏览器: http://127.0.0.1/phpinfo.php
    * 2. 让php使用tcp连接:
        *   只需要将nginx的default配置(所在目录/etc/nginx/sites-available/)
        * 配置中的`端口`改回来，然后再将php配置文件www.conf
        * (所在目录/etc/php5/fpm/pool.d/) `端口` 也该文与nginx的default端口中相同就行.
        * 相关语句: 
            * (nginx -> default) `fastcgi_pass 127.0.0.1:9000`
            * (php5-fpm -> www.conf) `listen = 127.0.0.1:9000`
        * 测试配置文件:
            * sudo service nginx start
            * sudo service php5-fpm start
        * 重载配置-`注意: 配置文件只有重载才生效`
            * sudo service nginx reload
            * sudo service php5-fpm reload
        * 重启服务:
            * sudo service nginx restart
            * sudo service php5-fpm restart
            
