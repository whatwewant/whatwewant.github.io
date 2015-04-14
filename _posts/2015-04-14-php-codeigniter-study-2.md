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

## Course 6 分页原理及实现
* 1. 分页原理介绍:
    * 1. 必须知道的一些参数:
        * a. 总共有多少条记录
        * b. 一页要有多少条记录
        * c. 总共有多少页
        * d. 当前页前后要显示及格分页链接
* 2. 利用CI的分页类实现分页列表:
    * 1. 设置一些CI分页基本参数:
        * 1. 总条数:
            * $config\['total\_rows'\]
        * 2. 一页显示几条:
            * $config\['per\_page'\]
        * 3. 定义当前页的前后各有及格数字链接:
            * $config\['num\_links'\]
        * 4. 定义没有分页参数，主URL:
            * $config\['base\_url'\]
    * 2. 调用CI的分页类:
        * $this->load->library('pagination');
    * 3. 执行分页方法:
        * $this->pagination->initialize(%config);
    * 4. 输出分页链接:
        * echo $this->pagination->create\_links();
    * 5. 查询部分数据(limit):
        * $this->db->limit($length, $start);
* 3. 其他:
    * 1. count($array); // 数组的长度

