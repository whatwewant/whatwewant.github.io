---
layout: post
title: "MySQL (三) 数据操作语言DML: JOIN/UNION/TRUNCATE ..."
keywords: [""]
description: "MySQL 数据操作篇"
category: SQL
tags: [MySQL, SQL, 数据库]
---
{% include JB/setup %}

## MYSQL 数据操作语法: Data Manipulate Language

### 一、JION 语法
* 1. JOIN Syntax

```
MySQL支持以下JOIN语法，主要用于SELECT语句的table_references部分
    和 多表 DELETE 和 UPDATE 语句

table_references:
    table_reference [, table_reference ...]

table_reference:
      table_factor
    | join_table

table_factor:
      tbl_name [[AS] alias]
        [{USE | IGNORE | FORCE} INDEX (key_list)]
    | (table_references)
    | { OJ table_reference LEFT OUTER JOIN table_reference 
            ON conditional_expr }

join_table:
      table_reference [INSERT | CROSS] JOIN table_factor [join_condition]
    | table_reference STRAIGHT_JOIN table_factor
    | table_reference STRAIGHT_JOIN table_factor ON condition
    | table_reference LEFT [OUTER] JOIN table_reference join_condition
    | table_reference NATURAL [LEFT [OUTER]] JOIN table_factor
    | table_reference RIGHT [OUTER] JOIN table_reference join_condition
    | table_reference NATURAL [RIGNT [OUTER]] JOIN table_factor

join_condition:
      ON condition_expr
    | USING (column_list)
```

* 2 JOIN Example:

```
-- 待续
```

### 二、UNION 语法
* 1 UNION Syntax: UNION用于把来自许多SELECT语句的结果组合到一个结果集中

```
    SELECT ...
    UNION [ALL | DISTINCT]
    SELECT ...
    [UNION [ALL | DISTINCT] SELECT ...]
```

* 2 UNION Example

```
-- 待续
```

### 三、TRUNCATE 语法:
* 1 TRUNCATE Syntax
    * TRUNCATE TABLE 用于完全清空一个表。逻辑上，等同于删除所有行的DELETE, 但实际上有所不同
    * 对于InnoDB表，如果有需要引用表的外键限制，则TRUNCATE TABLE被映射到DELETE上；否则使用快速删减（取消和重新创建表）。使用TRUNCATE TABLE重新设置AUTO_INCREMENT计数器，设置时不考虑是否有外键限制。

```
    TRUNCATE [TABLE] tbl_name;
```

* 2 TRUNCATE Example:

```
-- 待续
```

### 四、HANDLER 语法:
* 1 HANDLER Syntax:
    * 对于InnoDB表，如果有需要引用表的外键限制，则TRUNCATE TABLE被映射到DELETE上；否则使用快速删减（取消和重新创建表）。使用TRUNCATE TABLE重新设置AUTO_INCREMENT计数器，设置时不考虑是否有外键限制。
    * HANDLER...OPEN语句用于打开一个表，通过后续的HANDLER...READ语句建立读取表的通道。本表目标不会被其它线程共享，也不会关闭，直到线程调用HANDLER...CLOSE或线程中止时为止。如果您使用一个别名打开表，则使用其它HANDLER语句进一步参阅表是必须使用此别名，而不能使用表名。

```
HANDLER tbl_name OPEN [ AS alias ]
HANDLER tbl_name READ index_name { = | >= | <= | < } (value1,value2,...)
    [ WHERE where_condition ] [LIMIT ... ]
HANDLER tbl_name READ index_name { FIRST | NEXT | PREV | LAST }
    [ WHERE where_condition ] [LIMIT ... ]
HANDLER tbl_name READ { FIRST | NEXT }
    [ WHERE where_condition ] [LIMIT ... ]
HANDLER tbl_name CLOSE
```

* 2 HANDLER Example
```
-- 待续
```

### 五、LOAD DATA INFILE 语法
* 1 LOAD DATA INFILE:
    * LOAD DATA INFILE语句用于高速地从一个文本文件中读取行，并装入一个表中。文件名称必须为一个文字字符串。

```
LOAD DATA [LOW_PRIORITY | CONCURRENT] [LOCAL] INFILE 'file_name.txt'
    [REPLACE | IGNORE]
    INTO TABLE tbl_name
    [FIELDS
        [TERMINATED BY 'string']
        [[OPTIONALLY] ENCLOSED BY 'char']
        [ESCAPED BY 'char' ]
    ]
    [LINES
        [STARTING BY 'string']
        [TERMINATED BY 'string']
    ]
    [IGNORE number LINES]
    [(col_name_or_user_var,...)]
    [SET col_name = expr,...)]
```

### 六、REPLACE 语法:
...
