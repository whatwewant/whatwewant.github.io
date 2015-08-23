---
layout: post
title: "Linux Command: awk"
keywords: [""]
description: ""
category: Linux
tags: [Linux, Awk]
---
{% include JB/setup %}

### 一、简介
* `awk` 是处理文本数据的好工具。
* 相比于`sed`常用于一整行的处理，`awk`则倾向于将一行分成数个"字段"来处理.
* `awk`适合处理小型的文本数据.

### 二、语法

#### `awk '条件类型1{动作1} 条件类型2{动作2} ...' filename`
* `awk`主要是处理每一行的字段内的数据，而默认的字段的分隔符为空格或者[tab]键.
    * 案例: last取出登陆账号和IP
        * `last -n 5 | awk '{print $1 "\t" $3}'`
* 在每一行的每个字段都是有变量名的, 从$1开始, $2, $3, ...

### 三、处理流程
* 1 读入每一行，并将第一行的数据填入变量$0, $1,$2,...中
* 2 依据条件类型的限制, 判断是否需要进行后面动作
* 3 做完所有动作与条件类型

### 四、内置变量
* 注意:
    * `FS`和`-F`选项类似
    * 区别是: 
        * `FS`从第二行开始生效，如果要从第一行开始生效，则要加关键字`BEGIN`
            * `awk 'BEGIN {FS=":"} ...' ...`
        * `-F`选项默认从第一行开始生效
* 栗子:
    * 运用`NR`选择指定行
        * 只输出第一行: `last -n 5 | awk 'NR==1{print $1 "\t" $3}'`
        * 只输出第二行: `last -n 5 | awk 'NR==2{print $1 "\t" $3}'`
    * 运用`NF`得出总列数

|变量名称|代表意义|栗子|
|:------:|:-------|:---|
| NF | 每一行($0)拥有的字段总数, 也就是总列数 | 显示列数: `last -n 5 | awk '{print "User: " $1 "\t columns: " NF}'` |
| NR | 指定处理第几行数据, 也就是行号| 显示所在行数: `last -n 5 | awk '{print "User: " $1 "\t Line: " NR }'` |
| FS | 指定分隔符，默认是空格 | 分隔符为冒号, `awk 'last -n 5 | awk '{FS:":"} {print "User: " $1}'` |

### 五、逻辑运算符
* `>` `<` `>=` `<=` `==` `!=`
* 栗子:
    * 找出/etc/passwd中UID小于10的用户和UID, 其中awk中$1是用户, $3是UID
        * `cat /etc/passwd | awk '{FS=":"} $3 < 10 {print $1 "\t" $3}'`
    * 输出有误，不是从第一行开始输出，解决, 关键字`BEGIN`
        * `cat /etc/passwd | awk 'BEGIN {FS=":"} $3<10 {print $1 "\t" $3}'`
        * `cat /etc/passwd | awk -F ":" '$3<10 {print $1 "\t" $3}'`

### 六、其他高级用法:
* 1 数字可相加，可用printf格式化

```bash
pay.txt内容
    Name    1st     2st     3st
    VBird   2300    2400    2500
    Cole    1200    1234    1442
    Potter  1111    1122    3333
    ...

# 第一行加标题
# 第二行开始计算总和
cat pay.txt awk 'NR==1{printf "%10s %10s %10s %10s %10s\n", $1, $2, $3, $4, "Total"} \
    NR>=2{total=$1+$2+$3+$4 printf "%10s %10s %10s %10s %10s\n", $1, $2, $3, $4, total}'

# 注意: 
#   printf格式化字符串\n换行
#   与bash和shell不同，awk中的自定义变量可以直接使用, 不用加$符号，如total
```

* 2 支持条件判断`if`

```
cat pay.txt awk '{ if (NR == 1) printf "%10s %10s %10s %10s %10s\n", $1, $2, $3, $4, "Total"} \
    NR>=2{total=$1+$2+$3+$4 printf "%10s %10s %10s %10s %10s\n", $1, $2, $3, $4, total}'
```
