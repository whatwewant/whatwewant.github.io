---
layout: post
title: "mysql learning notes 之 INSERT DELETE UPDATE SELECT"
keywords: [DATA INSERT, DELETE, UPDATE, SELECT]
description: "SQL 数据的增删改查"
category: mysql
tags: [mysql, SQL, 数据库, INSERT, DELETE, UPDATE, SELECT]
---
{% include JB/setup %}

### 一. INSERT
* 1 语法

```
Syntax 1:
    INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
        [INTO] tbl_name [(col_name, ...)]
        VALUES ({expr | DEFAULT}, ....), ({expr | DEFAULT}, ...), ...
        [ON DUPLICATE KEY UPDATE col_name = expr, ...]

Syntax 2:
    INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
        [INTO] tbl_name
        set col_name={expr | DEFAULT}, ...
        [ON DUPLICATE KEY UPDATE col_name=expr, ...]

Syntax 3:
    INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
        [INTO] tbl_name [(col_name, ...)]
        SELECT ...
        [ON DUPLICATE KEY UPDATE col_name=expr, ...]
```

* 2 栗子

```
# create database if not exists student default character charset utf8;
# use student;
# create table if not exists Student (id int primary key auto_increment, Sname varchar(255) not null);
#
# 插入数据
方法一:
    insert into Student (Sname)
        values ('Lory');

方法二:
    insert into Student
        values ('Mark'); # 这里由于id是auto_increment, 所以可以省略; 否则不能, 必须全部字段都有值

方法三:
    insert into Student
        set Sname = 'Smith';

方法四: 插入多条
    insert into Student
        values ('Mary'), ('Maria'), ('Kiumi');

方法五: 
    insert into Student
        select 'Mr.Cao';

# 查看
select * from Student;
```

### 二、SELECT
* 1 语法

```
    SELECT
        [ALL | DISTINCT | DOSTINCTROW]
          [HIGH_PRIORITY]
          [STRAIGHT_JOIN]
          [SQL_SMALL_RESULT] [SQL_BIG_RESULT] [SQL_BUFFER_RESULT]
          [SQL_CACHE | SQL_NO_CACHE] [SQL_CALC_FOUND_ROWS]
        select_expr, select_expr, ...
        [INTO OUTFILE 'file_name' export_options
            | INTO DUMPFILE 'file_name']
        [FROM table_references
            [WHERE where_defination]
            [GROUP BY {col_name | expr | position}
                [ASC | DESC], ... [WITH ROLLUP]
              ]
            [HAVING where_defination]
            [ORDER BY {col_name | expr | position}
                [ASC | DESC], ...  
              ]
            [LIMIT {[offset,] row_count | row_count OFFSET offset}]
            [PROCEDURE procedure_name(argument_list)]
            [FOR UPDATE | LOCK IN SHARE MODE]
          ]
```

2. SELECT 栗子

```
-- 1. 显示Student表的所有数据
    select * from Student;

-- 2. 显示Student表的Sname列数据
    select Sname from Student;

-- 3. 条件Where
    select Sname
        from Student
        where id = 10;

-- 4. 限制Limit
    select Sname
        from Student
        limit 3;

-- 5. 分组GROUP BY, ASC(默认正序), DESC(逆序)
    select *
        from Student
        group by Sname
        desc;

-- 建表:
    drop table if exists Student;
    create table if not exists Student 
    (
        Sno integer int primary key, 
        Sname varchar(255) not null
    );
    create table if not exists Course
    (
        Cno integer primary key,
        Cname varchar(255)
    );
    create table SC
    (
        id integer auto_increment,
        Sno integer,
        Cno integer,
        primary key (id),
        foreign key (Sno) references Student (Sno),
        foreign key (Cno) references Course (Cno)
    );

-- 6. 连接多张基本表，通过where相同条件
    select Student.Sno, Student.Sname, Course.Cname, SC.Grade
        from Student, Course, SC
        where SC.Sno = Student.Sno and
              SC.Cno = Course.Cno;

-- 7. 按字段排序: ORDER BY 
    select * 
        from Student
        order by Sname
        desc;

-- 8. 输出到文件中 OUTFILE/DUMPFILE 'file_name':
    .... (待续)

-- 9. 条件之 HAVING where_defination
    ....
```
