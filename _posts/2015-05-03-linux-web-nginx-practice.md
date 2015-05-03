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
        *   nginx 本身不能处理PHP, 他只是个web服务器, 当接收到请求后,
        * 如果是php请求, 则发个php解释器处理，并把结果返回给客户端.
        * php-fpm 是一个守护进程(FastCGI进程管理器)用于替换PHP FastCGI的
        * 大部分附加功能, 对于高负载网站是非常有用的
    * 安装: sudo apt-get install php5-fpm
    * 安装好后连同上面的nginx一同测试:
        *   现在创建一个探针文件保存在 /usr/share/nginx/html 目录下
        * (这个目录是nginx配置文件中的root目录).
        * 新php文件: sudo vim /usr/share/nginx/html/phpinfo.php
        * 添加代码: <? php phpinfo();
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
            * (nginx -* default) `fastcgi_pass 127.0.0.1:9000`
            * (php5-fpm -* www.conf) `listen = 127.0.0.1:9000`
        * 测试配置文件:
            * sudo service nginx start
            * sudo service php5-fpm start
        * 重载配置-`注意: 配置文件只有重载才生效`
            * sudo service nginx reload
            * sudo service php5-fpm reload
        * 重启服务:
            * sudo service nginx restart
            * sudo service php5-fpm restart
            
## `NGINX HTTP 模块`
* `1. http index 模块`:
    * 语法: `index file1 file2 ...`;
    * 作用域: http, server, location
    * 模块功能及注意: 
        * 功能: 定义将要被作为默认页的文件
        * 注意: 文件的名字可以包含变量. 文件以配置中指定的顺序被nginx检测.
            * `列表的最好一个元素可以是一个带有绝对路径的文件`.
        * 例子: `index index.$geo.html index.0.html /index.html`:
            * `需要注意的是，index文件会引发内部重定向，请求可能会被其他location处理, 如下例2`
    * 模块: ngx_http_index_module 配置范例:例1

```bash 
// 例1
location / {
    index index.$geo.html index.html
}
```

```bash 
// 例2
location = / {
    index index.html;
}

location / {
    ....
}
// 请求"/"实际上将会在第二个location中作为"/index.html"被处理

* 2. `http log 模块`
    * 模块: ngx_http_log_module 配置范例: 例3
    * 指令:
        * access_log :
            * 语法: `access_log path [format [buffer=size | off]]`
            * 默认值: access_log log/access.log combined
            * 作用域: http, server, location
            * 模块功能及注意: 
                * 指令access_log指派路径、格式和缓存大小
                * 参数"off"将清除当前几倍的所有access_log指令。
                * 如果未指定格式，则使用预置的"combined"格式.
                * 缓存不能大于能写入磁盘的文件的最大值。在FreeBSD3.0-6.0, 缓存大小无限制.
        * log_format :
            * 语法: `log_format name format [format ...]`
            * 默认值: log_format combined "..."
            * 作用域: http, server

```bash
// 例3
log_format gzip '$remote_addr-$remote_user[$time_local]'
:'$request$status $bytes_sent'
:'"$ http _ referer" "$http_user_agent" "$gzip_ratio"';
access_log /spool/logs/nginx-access.log gzip buffer=32k;
```

* 3. `Access模块`
    * 1. 模块: ngx_http_access_module 功能描述:
        * 此模块提供简易的基于主机的访问控制.
        * ngx_http_access_module 模块使有可能对特定的IP客户端进行控制.
        * 规则检查第一次匹配的顺序，此模块对网络地址有放行和禁止的权利.
    * 2. Access 配置范例: 例4
    * 3. 放行: allow
        * 语法: allow [address | CIDR | all]
        * 作用域: http, server, location, limit_except
        * 功能: 网络地址有直接访问权限.
    * 4. 禁止: deny
        * 语法: deny [address | CIDR | all]
        * 作用域: http, server, location, limit_except
        * 功能: 网络地址拒绝访问.

```bash
// 例4
location / {
    deny  192.168.1.1;
    allow 192.168.1.0/24;
    allow 10.1.1.0/16;
    deny  all;
}
// 在上面的例子中，仅允许网段10.1.1.0/16和192.168.1.0/24中除了192.168.1.1之外的ip访问.
```

* 4. `Rewrite 模块`:
    * 1. 模块: ngx_http_rewrite_module
        * 功能描述: 
            * 执行URL重定向, 允许你去掉带有恶意的URL, 包含多个参数(修改);
            * 利用正则的匹配，分组和引用,达到目的配置范例.
            * 该模块允许使用`正则表达式改变URL,并根据变量来转向以及选择配置`
    * 2. 语法:
        * (1) if 语法
            * `if (condition) { ... }`
            * 作用域: server, location
            * 范例: 例5
        * (2) return 语法:
            * `return code;`
            * 作用域: server, location, if
            * 功能描述:
                * 这个指令规则的执行情况，返回一个状态值给客户端。
                * 可用值包括: 204, 400, 402-406, 408, 410, 411, 413, 416, 500-504.
                * 也可以发送非标准的444代码，未发送任何信息下结束连接.
        * (3) rewrite 语法:
            * `rewrite regex replacement flag;`
                * `last` : 表示完成
                * `rewrite break` : 本规则匹配完成, 终止匹配，不再匹配后面的规则
                * `redirect` : 返回302临时重定向，地址栏会显示跳转后的地址
                * `permanent` : 返回301永久重定向，地址栏会显示跳转后的地址.
            * 作用域: server, location, if
            * 功能描述:
                * 根据正则表达式或者替换字符来更改URL.
                * 指令根据配置文件中的先后顺序执行生效

```bash
// 例5
if ($http_user_agent ~ MSIE) {
    rewrite ^(.*)$ /msie/$1 break;
}
if ($http_cookie ~* "id=([^;]+)(?:;|$)" ) {
    set $id $1;
}
if ($request_method = POST) {
    return 405;
}
if (!-f $request_filename) {
    break;
    proxy_pass http://127.0.0.1;
}
if ($slow) {
    limit_rate 10k;
}
if ($invalid_referer) {
    return 403;
}
```

* 5. `Proxy模块`
    * 模块: ngx_http_proxy_module
    * 功能描述:
        * 此模块能代理请求到其他服务器
        * 也就是说允许你把客户端请求转到后端服务器
        * (这部分指令非常多，但不是全部都被用到)
    * 指令:
        * (1) pass_header
            * `proxy_pass_header Server;`
            * 功能描述: 
                * 该指令强制一些被忽略的头传递到客户端.
        * (2) redirect
            * `proxy_redirect off;`
            * 功能描述:
                * 允许改写出现在HTTP头却被后端服务器触发重定向的URL.
                * 对响应本身不做任何处理.
        * (3) set_header
            * `proxy_set_header Host $http_host;`
            * 功能描述:
                * 允许你重新定义代理header值再转到后端服务器
                * 目标服务器可以看到客户端的原始主机名.
        * (4) set_header
            * `proxy_set_header X-Real-IP $remote_addr;`
            * 功能描述:
                * 目标服务器可以看到客户端的真实ip, 而不是转发服务器的ip.
        * (5) [更多proxy指令](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)

* 6. `upstream 模块`
    * 1. 模块: `ngx_http_upstream_module`
    * 2. 功能简介:
        * 该指令使请求被上行信道之间的基于客户端的IP地址分布.
        * 范例: 例6
    * 3. 指令:
        * (1) `ip_hash`
            * 语法: `ip_hash;`
            * 作用域: upstream
            * 指令功能及注意:
                * 指定服务器租的负载均衡方法，请求基于客户端的IP地址在服务器间进行分发。
                * IPv4地址的前三个字节或者IPv6的整个地址，会被用来作为一个散列key.
                * 这种方法可以确保从同一个客户端过来的请求，会窗格同一台服务器.
                * 除了当服务器被认为不可用的时候，这些客户端的请求会被传给其他服务器，而且很有可能也是同一台服务器.
                * 如果其中一个服务器想暂时移除，应该加上down参数.这样可以保留当前客户端IP地址散列分布. 如`例6.1`
        * (2) `server`
            * 语法: `server address [parameters];`
            * 作用域: upstream
            * 指令功能及注意:
                * 定义服务器的地址address和其他参数parameters.
                * 地址可以是域名或者IP地址，端口是可选的，或者是指定"unix:"前缀的UNIX域套接字的路径.
                * 如果没有指定端口，就使用80端口.
                * 如果一个域名解析到多个IP, 本质上是定义了多个server.
            * 配置范例: 例6.2
        * (3) `upstream`
            * 语法: `upstream name { ... }`
            * 作用域: http
            * 指令功能及注意:
                * 功能: 描述一个服务器的集合，该集合可被用于proxy_pass和fastcgi_pass指令中, 作为一个单独的实体.
                * 这些服务器可以是监听在不同的端口，另外，并发使用同时监听TCP端口和Unix套接字的服务器是可能的。
                * 这些服务器能被分配不同的权重(weight).weight默认为1.
                * 配置范例: 例6.3

```bash
// 例6
upstream backend {
    server backend1.example.com weight=5;
    server backend2.example.com:8000;
    server unix:/tmp/backend3;
}

server {
    location / {
        proxy_pass http://backend;
    }
}
```

```bash
// 例6.1
upstream backend {
    ip_hash;
    server backend1.example.com;
    server backend2.example.com;
    server backend3.example.com down;
    server backend4.example.com;
}
```

```bash
// 例6.2
upstream backend {
    server backend1.example.com weight=5;
    server 127.0.0.1:8080       max_fails=3 fail_timeout=30s
    server unix:/tmp/backend3;
}
```

```bash
// 例6.3
upstream backend {
    server backend1.example.com weight=5;
    server 127.0.0.1:8080       max_fails=3 fail_timeout=30s;
    server unix:/tmp/backend3;
}
```

* 7 [NGINX全部模块](http://wiki.nginx.org/Modules)
