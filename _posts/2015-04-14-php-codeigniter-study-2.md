---
layout: post
title: "php codeigniter study 2"
keywords: ""
description: ""
category: php
tags: [php, session]
---
{% include JB/setup %}

## Course 5 SESSION机制和登陆验证
* 1. 利用SESSION进行登陆验证的原理:
    * 1. 基本流程:
        * 1. 客户端登陆: 用户输入用户名密码
        * 2. 服务端验证: 验证用户名和密码
        * 3. 生成SESSION, 并返回验证信息
    * 2. 一些常量:
        * 1. POST信息: $\_POST对象 (var\_dump($\_POST))
        * 2. GET信息: $\_GET对象
        * 3. COOKIE信息: $\_COOKIE
        * 4. SESSION信息: $\_SESSION
        * 5. SERVER信息: $\_SERVER
        * 6. FILE上传信息: $\_FILES
        * 7. ENV信息: $\_ENV
        * 8. REQUEST信息: $\_REQUEST
* 2. 利用CI框架进行SESSION登陆验证:
    * 1. CI的SESSION类:
        * 1. 修改配置: application/config/config.php:
            * $config\['encryption\_key'\]
            * 要使用SESSION, 该项不能为空
        * 2. 加载SESSION类:
            * $this->load->library('session')
            * 在system/libraries/session/
        * 3. 创建SESSION:
            * $this->session-set\_userdata($array)
        * 4. 查看SESSION:
            * $this->session->userdata(session名)
        * 5. 删除SESSION:
            $this->session->unset\_userdata('SESSION名');


