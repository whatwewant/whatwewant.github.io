---
layout: post
title: "Nginx 禁止未绑定域名(包括IP)范围"
keywords: [""]
description: ""
category: ServerEnd
tags: ["nginx"]
---
{% include JB/setup %}

### 问题
* `随意绑定域名到IP, 都可以访问；但是不想被其他未指定的域名绑定, 返回404或者其他.`

### 解决方法(一)
* 编辑 nginx.conf 或者 自己配置的server文件
* 在其他server里指定server_name, 比如: colesmith.space;

```
// 添加以下代码, 作为默认服务(访问)
// 其他 server 不能设置为default_server;
// 检测: nginx -t
// vim /etc/nginx/nginx.conf
server {
    listen      80 default_server;
    server_name _;
    return      404; 
}
```

```
// 在其他server里指定server_name, 比如: colesmith.space
// 浏览器访问: http://colesmith.space 可以访问
// 其他域名即使绑定，也指向404页面
// 
// server_name 可以指定IP， 开放IP访问
// server_name 可以指定多个域名，用空格隔开
server {
    listen      80;
    ...
    server_name colesmith.space love.me 112.113.114.115;
    ...
}
```

### 解决方法(二)
* 编辑nginx.conf
    * 1 设置default_server
    * 2 设置server_name, 限制指定域名访问，其他域名404页面
    * 3 在default_server中用try_files
        * `try_files $uri $uri/ @error` (Django or other)
        * `try_files $uri $uri/index.php?$args 404` (PHP or other)
* [参考](http://stackoverflow.com/questions/17798457/how-can-i-make-this-try-files-directive-work)

```
// 
server {
    listen      80 default_server;
    server_name colesmith.space 111.222.333.444;
    ...

    location / {
        ...
        try_files $uri $uri 404;
    }
    ...
}
```

### 相关
* [Nginx 官方文档](http://nginx.org/en/docs/)
* [Nginx开发从入门到精通](https://github.com/taobao/nginx-book)
