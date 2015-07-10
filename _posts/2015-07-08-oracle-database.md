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

### 四、管理数据: INSERT UPDATE DELETE
* 1 添加/插入数据

```
Syntax:
    INSERT INTO tbl_name[(column1, column2...)] VALUES (value1, value2 ...)

Example:
    INSERT INTO tb_user(id, user_name, user_password) VALUES (2015, 'Gardom', '123456');
```

* 2 使用序列

```
-- 1 创建序列:
    -- Syntax:
        CREATE SEQUENCE squence_name
            START WITH 1    -- 从1开始
            INCREMENT BY 1  -- 每次加1
            MAXVALUE 2000   -- 最大值2000
            MINVALUE        -- 最小值
            NOCYCLE         -- 不循环
            NOCACHE;        -- 不缓存

    -- Example:
        CREATE SEQUENCE user_seq
            START WITH 1
            INCREMENT BY 1;

-- 2 序列操作:
    -- Syntax:
        -- 访问序列的值
            - NEXTVALUE : 返回系列的下一个值
            - CURRVAL   : 返回序列的当前值(第一次NEXTVAL初始化后才能用CURRVAL)
            -- 栗子:
                SELECT user_seq.CURRVAL FROM dual;

            -- Tips:
                dual是Oracle中的虚拟表，可用于查看当前用户，当前系统时间等，序列值.

        -- 更改序列
            -- 栗子
                ALTER SEQUENCE user_seq MAXVALUE 5000; -- 更改序列
                DROP SEQUENCE user_seq;

        -- 运用
            -- 栗子
                INSERT INTO tb_user (id, user_name, user_password)
                    VALUES (user_seq.nextval, 'gardon', '123456');
            
```

* 3 修改数据
    * 提交(COMMIT)和回滚(ROLLBACK):　这里所说的都是对Oracle DB, 其他不一定
        * 提交(COMMIT):
            * DML语言，需要commit:
                * 比如update, delete, insert等修改表中数据
            * 其他，如DDL语言，不需要回滚
                * 比如create, drop等改变表结构的，因为内部隐藏了commit
        * 回滚(ROLLBACK)
            * `必须在没有提交之前才可以回滚；提交后只能查看日志`
    * 修改数据UPDATE

```
UPDATE Syntax:
    UPDATE tbl_name
        SET column_name = new_value
            [, column_name2 = new_value2 ...]
        [WHERE condition_expression];
    COMMIT; -- Oracle DB need commit.

UPDATE Example:
    -- 根据ID修改用户密码
        UPDATE tb_user 
            SET user_password = '654321' 
            WHERE id= '1';
        COMMIT;

    -- 更新所有数据，即不要WHERE条件语句, 注意安全
        UPDATE tb_user
            SET user_password = '654321';
```

* 4 删除数据

```
Syntax:
    DELETE FROM tb_user
        [WHERE condition_expression];

Example:
    -- 根据ID删除用户
        DELETE FROM tb_user
            WHERE id = '1';
        COMMIT;

    -- 删除整个表, Carefully
        DELETE FROM tb_user;
        COMMIT;
```

### 五、查询数据
* 1 基础SELECT
    * 含义: 查询(SELECT)语句用于从表中选取数据,结果存储在一个虚拟的结果表中.

```
Syntax:
    SELECT column_name [, column_name2 ...]
        FROM tbl_name
        [WHERE condition_expression]
        [ORDER BY column_name [ASC | DESC]];

Example:
    SELECT id, user_name
        FROM tbl_user
        WHERE user_name='gardom' and user_password='123456';
```

* 2 模糊SELECT: LIKE, _

```
Syntax:
    -- % : 代表零个或多个字符
    -- _ : 只能代表一个字符
        WHERE column_name LIKE '%str%';
        WHERE column_name LIKE '%str';
        WHERE column_name LIKE 'str%';
        WHERE column_name LIKE '_str';
        WHERE column_name LIKE 'str_';
        WHERE column_name LIKE '_str_';
        WHERE column_name LIKE 'str1_str2'; 
        WHERE column_name LIKE '_str%'; .....
```

* 3 多表SELECT
    * 1 等值连接: 返回多个表中所有能匹配的记录
        * `SELECT t.*, i.* FROM tb_type t, tb_info i WHERE t.type_sign = i.info_type;`
        * `-- t, i为表的别名;`
    * 2 左连接  : 以左表为基础,即使右表中没有匹配，也从左表返回所有行
        * `LEFT JOIN`
        * `SELECT t.*, i.* FROM tb_type t LEFT JOIN tb_info i ON t.type_sign = i.info_type;`
    * 3 右连接  : 以右表为基础, ...
        * `RIGHT JOIN`
    * 4 全关联  : 只要其中一个表中存在匹配，就返回所有行
        * `FULL JOIN`
* 4 Oracle伪列
    * 伪列: 就想一个表列，但是它并没有存储在表中;
    * 伪列可以在表中查询，但不能插入、更新和删除;
    * 常用伪列:
        * ROWID 是表中行的存储地址;
            * 该地址可以唯一表示数据库中的一行;
        * ROWNUM 是查询返回的结果中行的序号
            * 可以使用它来限制查询返回的行数
            * 通常用来分页.

* 5 子查询和分页SQL
    * 子查询: 嵌套查询
    * 分页:

```
-- 分页:
    SELECT * 
        FROM (
            SELECT a.*, ROWNUM rn 
                FROM (
                    SELECT * FROM tb_info ORDER BY info_date DESC
                    ) a
                WHERE ROWNUM <= 5 -- 注意，子查询不用写分号
        ) 
        WHERE rn >= 2;
```
