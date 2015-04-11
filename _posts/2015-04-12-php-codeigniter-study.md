--- 
layout: post
title: "PHP CodeIgniter Framework Study"
keywords: ""
description: "CodeIgniter Study Notes"
category: php
tags: [php, ci, codeigniter]
---
{% include JB/setup %}

## Course 1. Entrance To CodeIgniter
* 1. MVC简单介绍:
    * 1. 解释:
        * M: Model (数据模型)
        * V: View (用户界面)
        * C: Controller (控制器)
    * 2. 
* 2. CI的简单介绍
* 3. CI的目录结构和工作流程:
    * CodeIgniter2.0.0目录结构:
        * index.php : 应用主入口文件
        * system: 矿建核心程序目录:
            * core : 核心程序: 框架的基类、初始化
            * database : 数据库操作相关程序
            * fonts : 字库
            * helpers : 辅助函数
            * language : 语言包
            * libraries : 通用类库，比如验证、缓存、图像处理
        * application : 项目目录:
            * cache : 存放数据或模板缓存文件
            * config : 与目录相关的配置
            * controllers : MVC的控制器，继承CI\_Controller
            * core : 项目的核心程序
            * errors : 错误提示模板
            * helpers : 项目的辅助函数
            * hooks : 钩子，在不修改系统核心文件的基础上扩展系统功能
            * language : 语言包
            * libraries : 通用类库
            * logs : 日志
            * models : MVC的模型, 一般继承CI\_Model
            * third\_party : 第三方类库
            * views : MVC的视图，主要是模板
    * CI的业务流程:
        * 入口 -> 控制器 -> 方法 -> 参数:
            * 1.index.php -> URL路由 -> 安全过滤 -> 控制器 -> 模型/类库/辅助函数/插件/脚本
            * 2. 控制器-> 视图 -> 缓存 -> index.php 显示
        * `注意，每一个控制器都是一个类Class, 在每个Class里面的function都是一个页面`
        * URL:
            * http://localhost
            * http://localhost/index.php
            * http://localhost/index.php/welcome
            * http://localhost/index.php/welcome/index.php
            * `[SERVER]/[Controller-Class]/[Controller-Method]/[Arguments]`
            * `默认控制器在: application/config/routes.php中有$route['default_controller']配置默认`
* 4. 如何创建并操作一个CI控制器:
    * 1. 什么是控制器:
        * 一个控制器是一个类文件，用户通过URL访问的就是某个控制器类中的具体成员方法，并由这个方法中的代码去做某些操作
    * 2. 如何创建控制器:
        * a. 进入application\controllers目录
        * b. 控制器文件名必须和类名一致，并且类名必须以大写之母开头
        * c. 继承核心的控制器类CI\_Controller
    * 3. 创建方法:
        * a. 创建一个成员方法 function funName ...
        * b. 默认访问的是index方法
    * 4. URL如何传递参数给方法:
        * 方法段后的按次序传入方法中的形式参数

## Course 2 Controller And Views
* 1. 简述视图与控制器的关系:
    * 1. 控制器:
        * 调用视图: 控制器需要根据用户的访问的不同方法，去调用相关视图
        * 传送数据: 控制器需要向视图中传送需要展示个用户的业务数据
    * 2. 视图:
        * 一个视图就是一个网页或网页的部分
        * application\views文件夹
* 2. CI如何创建视图:
    * 进入application/views
    * 创建php文件
    * 写HTML嵌入PHP代码
* 3. CI控制器如何调用视图:
    * a. 调用一个视图:
        * $this->load->view('viewName') 
        * 这里 viewName是application/views中创建的视图文件名
        * 注意这里的视图文件一般以php结尾, 可以省去.php; 如果不是以.php结尾, 那么必须写完整的视图文件名
    * b. 调用多个视图:
        * $this->load->view('v1');
        * $this->load->view('v2');
        * $this->load->view('v3');

* 4. CI控制器如何向视图传值:
    * a. 介绍:
        * 数据通过控制器以一个数组或是对象的形式传入视图，这个数组或对象作为视图载入函数的第二个参数
        * $this->load->view('viewName', ArrayOrObject);
    * b. 实例:
        * $data['title'] = 'Title First';
        * $data = array('name' => $name, 'count'=>$count)
        * $this->load->view('test_view', $data)
    * c. 解释
        * 传入的是对象或数组
        * 视图中使用的是键名$name对象获取对应键值$value; 
    * d. 一些函数:
        * @$count = file_get_contents($fileName);
        * $resource = fopen($fileName, 'w');
        * fwrite($resource, $count);
        * fclose($resource);

## Course 3. 模型Model
* 1. 模型的介绍:
    * 1. 模型是一个数据库类
    * 2. 一个模型针对一张表
    * 3. 类中的方法是针对功能的具体需求而做的
* 2. 如何利用CI进行模型创建(增删改查):
    * 1. 模型的存放目录:
        * application/models
    * 2. 创建模型就是创建一个类文件:
        * 必须继承核心类CI_Model, 同上重载父类中的构造方法
    * 3. 配置数据库: application/config/database.php:
        * 1. ...

```php
class Model_Name extends CI_Model {
    function __construct () {
        parent::__construct();
        $this->load->database();
    }
}
```

* 3. CI 为我们提供了一个强大而简单的数据库函数类:
    * Active Record 类: system/database/DB_active_rec.php
    * (3.0.0: system/database/DB_query_builder.php)
* 4. 如何在模型中使用Active Record类中的方法呢:
    * $this->db->方法名()
    * 例如: $this->db->get('entries', 10); // 10是默认值
    * 方法:
        * 1. 连接数据库: $this->load->database():
            * 写在模型的构造函数里，这样加载模型的同时就连接上数据库了
        * 2. 插入数据: $this->db->insert($table_name, $data);:
            * 参数:
                * $table_name 表名
                * $data=你要插入的数据(键名=字段名, 键值=字段值, 自增主键不用写)
        * 3. 更新数据:
            * $this->db->where(字段名, 字段值);
            * $this->db->update(表名, 修改的数组);
        * 4. 查询数据:
            * $this->db->where(字段名, 字段值);
            * $this->db->select(字段);
            * $query = $this->db->get(表名);
            * return $query->result();
            * `var_dump($query->result);` 输出一个对象的。。。
        * 5. 删除数据:
            * $this->db->where(字段名, 字段值);
            * $query->db->delete(表名);
* 5. 在Controller中载入模型:
    * $this->load->model(模型名);
    * $this->模型名->方法
