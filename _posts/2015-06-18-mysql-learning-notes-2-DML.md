---
layout: post
title: "MySQL (二) 数据操作语言(DML): INSERT DELETE UPDATE SELECT"
keywords: [DATA INSERT, DELETE, UPDATE, SELECT]
description: "SQL 数据操作语言DML"
category: SQL
tags: [mysql, SQL, 数据库, INSERT, DELETE, UPDATE, SELECT]
---
{% include JB/setup %}

## 数据操纵语言(DML): Data Manipulate Language

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
        Grade integer,
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

-- 10 Like
    select title, category
        from movie_table
        where
            title like 'A%'
            and
            category = 'family'
        order by title;

-- 11 分组->求和sum/求平均avg->排序
    select first_name, sum(sales)
        from cookie_sales
        group by first_name
        order by sum(sales) desc;

-- 12 不同的值只返回一次，返回的结果没有重复值(distinct)
    select distinct first_name
        from cookie_sales;

-- 13 限制条数，并返回指定位置
    select first, count(day)
        from cookie_sales
        group by first_name
        order by count(day) desc
        limit 0, 4;  -- 从0位置开始，取四条结果
        /*取第二名: limit 1 1;*/

-- 14 函数: MAX MIN SUM AVG COUNT

```

### 三、UPDATE
* 1 UPDATE 语法

```
Single-table 语法:
    UPDATE [LOW_PRIORITY] [IGNORE] tbl_name
        SET col_name1=expr1 [, col_name2=expr2 ...]
        [WHERE where_defination]
        [ORDER BY ...]
        [LIMIT row_count];

Multiple-table 语法:
    UPDATE [LOW_PRIORITY] [IGNORE] table_references
        SET col_name1-expr1 [, col_name2=expr2 ...]
        [WHERE where_defination];
```

* 2. UPDATE 栗子

```
-- 1. 更新一个字段(列)的所有值
    update SC
        set Grade = 100;

-- 2. 按条件更新
    update SC
        set Grade = 88
        where Sno = 200215123 and Cno = 1;

-- 3. 排序限制条数
    update SC
        set Grade = Grade + 2 -- 这是mysql单行注释, 可以做加减乘除 
        where Cno = 2        
        oreder by Grade desc  # 这也是单行注释，排序
        limit 5;

-- 4. 多表操作:
    .... (待续)

-- 5. 多个条件，更新不同值
    update movie_table
        set category = 
            case
                when drama = 'T' then 'drama'
                when comedy = 'T' then 'comedy'
                when action = 'T' then 'action'
                when gore = 'T' then 'horror'
                when scifi = 'T' then 'scifi'
                when for_kide = 'T' or cartoon = 'T' then 'family'
                else 'misc'
            end;
```

### 四、DELETE
* 1 DELETE 语法

```
Single-Table 语法:
    DELETE [LOW_PRIORITY] [QUICK] [IGNORE]
        FROM tbl_name
        [WHER where_defination]
        [ORDER BY ...]
        [LIMIT row_count];

Multiple-Table 语法:
    DELETE [LOW_PRIORITY] [QUICK] [IGNORE]
        tbl_name[.*], [, tbl_name[.*] ...]
        FROM table_references
        [WHERE where_defination];
    或者
    DELETE [LOW_PRIORITY] [QUICK] [IGNORE]
        FROM tbl_name[.*] [, tbl_name[.*] ...]
        USING table_references
        [WHERE where_defination];
```

* 2 DELETE 栗子(慎用)

```
-- 1. 删除一个表中的所有数据(慎用)
    delete from a;

-- 2. 满足条件就删除
    delete from SC
        where Grade = 0;

-- 3. 排序限制: 去掉最高分
    delete from SC
        order by Grade desc
        limit 1;

-- 4. 多表:
    ....(待续)
```
