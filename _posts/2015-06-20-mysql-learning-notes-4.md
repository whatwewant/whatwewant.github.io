---
layout: post
title: "MySQL Learning 4-数据库管理语句"
keywords: ["数据库管理语句"]
description: ""
category: mysql
tags: [MySQL, SQL, 数据库, 数据库管理语句]
---
{% include JB/setup %}

## MySQL 数据库管理语句: 
1. CREATE/DROP USER
2. GRANT + REVOKE
3. SET PASSWORD
4. SHOW ...

### 一、CREATE USER 语法
1. CREATE USER Syntax:

```
    CREATE USER username [IDENTIFIED BY [PASSWORD] 'password']
        [, username [IDENTIFIED BY [PASSWORD] 'password'] ...];
```

2. CREATE USER 栗子:

```
-- 1. 创建无密码用户:
    create user no_password;
    exit;
    mysql -uno_password /*目前无任何权限*/

-- 2. 创建密码用户:
    create user what identified BY 'what';
    mysql -uwhat -pwhat
```

### 二、DROP USER 语法
1. DROP USER Syntax

```
    DROP USER username [, username, ...]
```

2. DROP USER Example:

```
    drop user what;
```

### 三、GRANT 和 REVOKE 语法
1. GRANT and REVOKE Syntax

```
    GRANT priv_type [(column_list)] [, priv_type [(column_list) ...]]
        ON [object_type] {tbl_name | * | *.* | db_name.*}
        TO username [IDENTIFIED BY [PASSWORD] 'password_string']
            [, username [IDENTIFIED BY [PASSWORD] 'password_string'] ...]
        [REQUIRE
            NONE |
            [{SSL | X509}]
            [CIPHER 'cipher' [AND]]
            [ISSUER 'issuer' [AND]]
            [SUBJECT 'subjectr']
          ]
        [WITH with_option [with_option] ...]


    object_type =
          TABLE
        | FUNCTION
        | PROCEDURE

    with_option = 
          GRANT OPTION
        | MAX_QUERIES_PER_HOUR count
        | MAX_UPDATES_PER_HOUR count
        | MAX_CONNECTIONS_PER_HOUR count
        | MAX_USER_CONNECTIONS count

```

```
    REVOKE priv_type [(column_list)] [, priv_type [(column_list)] ...]
        ON [object_type] {tbl_name | * | *.* | db_name.*}
        FROM username [, username, ...];

    REVOKE ALL PRIVILEGES, GRANT OPTION FROM username [, username ...];
```

2. GRANT and REVOKE Example

```
-- 1. 赋予用户what权限select
    grant select
        on table Student
        to what;

-- 2. 赋予用户what对表Student的权限: 
    -- select, insert, update, delete, create, drop
    grant select, insert, update, delete, create, drop # 注意, 这里create 并没什么卵用
        on table Student
        to what;

-- 3. 赋予用户在数据库student中创建表: CREATE
    grant create
        on table student.* -- 注释: 注意, 数据库名.* 才行，如果指定单表则无效
        to what;

-- 4. 赋予用户what对数据库student的所有权限
    grant all privileges
        on student.*
        to what;

-- 5. 赋予用户what@'192.168.1.%'所有数据库权限
    -- @'192.168.1.%' 表示用户的范围
    -- 默认自带what@localhost
    -- show grants查看;
    grant all privileges
        on *.*
        to what@'192.168.1.%';

-- 6. 查看用户权限
    show grants;

-- 7. 拥有赋予他人权限的权限: WITH GRANT OPTION
    grant select, insert
        on table student.*
        to what@localhost
        with grant option;

-- 8. ALTER 权限
    grant alter
        on table student.Student
        to what;

-- 9. 待续
```

```
-- 1. 收回用户what对表Student的select权限
    revoke select
        on table student.Student
        from what;

-- 1.1
    revoke select, insert, drop
        on table student.Student
        from what

-- 2. 收回用户what对数据库student的所有权限及GRANT OPTION
    revoke all privileges, grant option
        on table student.*
        from what;

-- 3. 收回用户what的所有权限
    revoke all privileges, grant option
        from what;
```

### 四、RENAME USER 语法 ( --> RENAME TABLE 语法)
1. RENAME USER 语法 和 栗子

```
Syntax:
    RENAME USER old_user TO new_user
        [, old_user TO new_user];

Example:
    rename user what to student_user;
```

### 五、SET PASSWORD 语法(设置密码)
1. SET PASSWORD Syntax

```
    SET PASSWORD = PASSWORD('some password for current user');
    SET PASSWORD FOR user_name = PASSWORD('password for user_name');
    
    * user_name值应该以user_name@host_name的格式给定
```

### 六、SHOW 语法
1. SHOW Syntax

```
-- 1. 显示所有有权限的数据库
    SHOW DATABASES;
    栗子: show databases;

-- 2. 显示所有表
    SHOW TABLES;
    栗子: show tables; (必须进入数据库: use database_name;)

-- 3. 显示创建表的语句：
    SHOW CREATE TABLE table_name;
    栗子: show create table Student;

-- 4. 显示创建数据库/模式语句
    SHOW CREATE {DATABASE | SCHEMA} db_name;
    栗子: show create database mysql;

-- 5. 显示权限:
    SHOW GRANTS [FOR user];
    栗子: show grants; -- 当前用户所拥有的权限
          show grants for what; -- 用户 what 有的权限
    注意: user 应该以 user_name@host_name 的形式

-- 6. 显示MySQL服务器所支持的系统权限清单
    SHOW PRIVILEGES;

-- 7. 显示正在运行的线程、用户等
    SHOW [FULL] PROCESSLIST;
    栗子: show processlist;

-- 8 还有很多 ....
```
