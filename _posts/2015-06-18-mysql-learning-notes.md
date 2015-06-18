---
layout: post
title: "MySQL Learning Notes"
keywords: [mysql]
description: mysql
category: mysql
tags: [mysql, 数据库]
---
{% include JB/setup %}

## MYSQL

### 三. MySQL语句语法:

#### 一、数据定义语言
* 1 创建数据库/模式: CREATE DATABASE/SCHEME 语法

```
Syntax:
    create {database | schema} [IF NOT EXISTS] db_name
        [create_specification [, create_specification] ...];

    create_specification 选项:
        [DEFAULT] CHARACTER SET charset_name |
        [DEFAULT] COLLATE collation_name;

    # 栗子:
    1. create database blog;
    2. create database if not exist blog;
    3. create database blog;
        default character set utf8;
    4. create database if not exists blog
        default character set utf8;
    5. create schema blog
        default character set utf8;
```

* 2 创建索引: CREATE INDEX 语法

```
Syntax:
    CREATE [UNIQUE | FULLTEXTISPATIAL] INDEX index_name
        [USING index_type]
        ON tbl_name (index_col_name);
    
    index_col_name 选项:
        col_name [(length)] [ASC | DESC];

    # 栗子
    # show databses;
    # create database if not exist t;
    # use t;
    # show tables;
    # create table t (a int primary key auto_increment, b varchar(255));
    # desc table_name;
    create index t_index 
        on t (a desc, b);
```

* 3 创建表: CREATE TABLE 语法
        
```

```
