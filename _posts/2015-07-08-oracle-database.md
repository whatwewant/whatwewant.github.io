---
layout: post
title: "Oracle Database"
keywords: [""]
description: ""
category: "SQL"
tags: ["sql", 'oracle']
---
{% include JB/setup %}

### 一、Orcle Database 数据库客户端的安装
* 安装
* 概述
    * 数据库 <-1-----n-> 表空间
    * 表空间 <-1-----n-> 表+索引+视图等

### 二、表空间(tablespace)及用户管理(grant/revoke)
* 1 TableSpace

```
-- 1. Create TableSpace
    CREATE TABLESPACE tablespace_name
    DATAFILE 'path/to/database_file'
    SIZE size;

    -- Ex
        CREATE TABLESPACE jsp_20150708
        DATAFILE '/home/potter/jsp_20150708.oradb'
        SIZE 100M;

```

* 2 管理用户
    * 默认用户
        * 1 `SYS` : 超级用户,具有最高权限 | sysdba角色权限 | create database权限
            * 主要用来维护系统信息和管理实例
        * 2 `SYSTEM` : 操作管理员, 权限: sysoper角色 | 没有create database权限
            * 管理数据库用户、权限和存储等
        * 3 `SCOTT` : 普通用户

```
-- CREATE USER 语法:

    -- CREATE USER username
       IDENTIFIED BY password
       [DEFAULT TABLESPACE tablespace_name];

    -- Ex
        -- CREATE USER gardom
           IDENTIFIED BY 123456
           DEFAULT TABLESPACE jsp_20150708.oradb;
```

* 3 用户权限与角色
    * 权限: 创建用户后必须赋予权限才可以登陆，权限是指执行特定类型sql命令或访问其他方案对象的权利
        * Ex: CREATE SESSION # 连接数据库权限;
                  CREATE TABLE   # 创建表的权限等
    * 角色:
        * 含义: 相关权限的命令集合，使用角色的目的是简化权限的管理
            * Ex: CONNECT, RESOURCE

* 4 授权语法: 权限或角色
    * Syntax: `GRANT privilege_name or role TO user`
    * Ex:
        * 1 GRANT CREATE SESSION TO gardom; -- 单行注释
        * 2 GRANT CREATE RESOURCE, CONNECT TO /*多行注释*/

### 三、对表操作: 就是普通SQL语句。。
* 1 添加表CREATE TABLE

```
Syntax:
    CREATE TABLE tbl_name (
        column_name1 data_type [constraint_type],
        column_name2 data_type [constraint_type],
        column_name3 data_type [constraint_type],
        ....
    );

Ex:
    CREATE TABLE tb_user (
        id NUMBER(5) PRIMARY KEY,
        user_name NVARCHAR2(20) NOT NULL,
        user_password NVARCHAR2(30) NOT NULL
    );
```

* 1.1 五大约束: 普通SQL, 这里就不再赘述了
    * 1 `NOT NULL`: -- 命名规范: nn_name
    * 2 `UNIQUE` -- 命名规范: uk_name (uk --> unique key)
    * 3 `PRIMARY KEY` -- 命名规范: pk_name (pk --> primary key)
    * 4 `FOREIGN KEY tbl_name(column_name)` -- 命名规范: fk_name
    * 5 `CHECK(condition_expression)` -- 命名规范: ck_name

* 2 修改表ALTER TABLE:
    * Syntax:
        * `ALTER TABLE table_name ADD (列名 数据类型 [约束]); -- 添加列，多列用逗号隔开`
        * `ALTER TABLE tb_name MODIFY (column_name data_type [约束]); -- 修改列属性`
        * `ALTER TABLE tb_name ADD CONSTRAINT constraint_name PRIMARY KEY(column_name); -- 添加约束，这里是主键`
        * `DESC tb_name; -- 查看表结构`
* 3 删除表DROP TABLE:
    * Syntax:
        * `DROP TABLE tbl_name; -- 删除表`
* 4 注释：
    * Syntax:
        * `COMMENT ON TABLE tbl_name IS 'tbl_comments'; -- 为表添加注释语句`
        * `COMMENT ON COLUMN column_name IS 'col_comments'; -- 为列`
    * Ex:
        * COMMENT ON TABLE tb_user IS 'User Table';

* 5 解释:
    * `SQL` 含义:
        *Structure Query Language, 结构化查询语句,针对数据库的
    * `SQL 分类`:
        * 1 `数据控制语言(DCL)`: 提取权限控制命令
            * `GRANT` and `REVOKE`
        * 2 `数据定义语言(DDL)`: 用于改变数据库结构
            * `CREATE` `ALTER` `DROP`
        * 3 `数据操纵语言(DML)`: 用于检索修改和插入数据
            * `INSERT` `SELECT` `DELETE` `UPDATE`
        * 4 `事物控制语言(TPL)`: 保证事务的执行
            * `COMMIT` `ROLLBACK` `SAVEPOINT`
    * `PL/SQL`:
        * 含义: 是Oracle对SQL的扩展语言
        * 功能: SQL的基础上，可以使用变量和逻辑控制语句编写功能模块，完成复杂要求.
        * 栗子

```
    SET serveroutput ON; -- 打开输出选项
    DECLARE
        -- 定义字符串变量
        v_ename VARCHAR2(10);
    BEGIN
        -- 执行部分
        -- & 表示要接收从控制台输入的变量
        SELECT ename INTO v_name FROM emp WHER empno=&empno;
        dbms_output.put_line('雇员名:' || v_name); -- 在控制台显示雇员名
    END;
```

* 完整表demo

```
    CREATE TABLE tb_user (
        id NUMBER(5) primary key,
        user_name NVARCHAR2(20) NOT NULL,
        user_password NVARCHAR2(30) NOT NULL
        );
    COMMENT ON COLUMN tb_user.id IS '标识';
    COMMENT ON COLUMN tb_user.user_name IS '用户名';
    COMMENT ON COLUMN tb_user.user_password IS '密码';

    CREATE TABLE tb_type 
    (
        id NUMBER(5) PRIMARY KEY,
        type_sign NUMBER(10) UNIQUE,
        type_name NVARCHAR2(20) NOT NULL,
        type_intro NVARCHAR2(100) 
    );
    COMMENT ON COLUMN tb_type.id IS '序号';
    COMMENT ON COLUMN tb_type.type_sign IS '标识';
    COMMENT ON COLUMN tb_type.type_name IS '类型名';
    COMMENT ON COLUMN tb_type.type_intro IS '信息类别';

    CREATE TABLE tb_info 
    (
        id NUMBER PRIMARY KEY,
        info_type NUMBER NOT NULL,
        info_title NVARCHAR2(80) NOT NULL,
        info_linkman NVARCHAR2(50) NOT NULL,
        info_phone NUMBER,
        info_date DATE,
        info_state NVARCHAR2(10),
        info_content NVARCHAR2(1000),
        info_email NVARCHAR2(30),
        info_payfor NVARCHAR2(20),
        FOREIGN KEY (info_type) REFERENCES tb_type(type_sign)
    );
    COMMENT ON COLUMN tb_info.id IS '序号';
    COMMENT ON COLUMN tb_info.info_type IS '类型';
    COMMENT ON COLUMN tb_info.info_title IS '标题';
    COMMENT ON COLUMN tb_info.info_linkman IS '联系人';
    COMMENT ON COLUMN tb_info.info_phone IS '电话';
    COMMENT ON COLUMN tb_info.info_date IS '日期';
    COMMENT ON COLUMN tb_info.info_state IS '审核状态';
    COMMENT ON COLUMN tb_info.info_content IS '内容';
    COMMENT ON COLUMN tb_info.info_email IS '邮箱';
    COMMENT ON COLUMN tb_info.info_payfor IS '付费状态';
```
