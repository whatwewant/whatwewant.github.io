---
layout: post
category: SQL
tags: [sql, mysql, note]
---
{% include JB/setup %}

## 1. SQL 创建篇
* 1. 创建数据库: CREATE DATABASE dbname;
* 2. 使用数据库: USE dbname
* 3. 创建表:

    ```bash
     CREATE TABLE tableName
     (
        name VARCHAR(10),
        weight DEC(5, 2)
     );
    ```

* 4. 数据类型: `CHAR, VARCHAR, BLOB, INT, DEC, DATE, DATETIME`
* 5. 列出某表的所有字段详细情况: DESC tableName; 
  * DESC　是 DESCRIBE 的缩写
* 6. 删除表: DROP TABLE tableName;

## 2. SQL 数据处理篇
* 1. 插入数据:

```bash
    INSERT INTO tableName 
    (column_name1, column_name2, ...)
    VALUES
    (value1, value2, ...);
```

* 2. 查询所有数据: `SELECT * FROM tableName`
* 3. 设置字段非空NOT NULL属性:
    * 注意: `NULL != NULL; NULL != BLANK`

```bash
    CREATE TABLE tableName 
    (
        lastname VARCHAR(30) NOT NULL
    );
```

* 4. 缺省/默认属性: DEFAULT:

```bash
    CREATE TABLE tableName
    (
        cost DEC(3, 2) NOT NULL DEFAULT 1.00
    );
```
