---
layout: post
title: "MySQL (五) 函数和操作符"
keywords: [""]
description: ""
category: SQL
tags: [MySQL, SQL, 数据库]
---
{% include JB/setup %}

## 导航

### 一、操作符
* 1 操作符优先级

|操作符|优先级|
|:-----|:----:|
|BINARY, COLLATE|15|
|!|14|
|-(一元减号), ~(一元比特取反)|13|
|^|12|
|*, /, DIV, %, MOD|11|
|-, +|10|
|<<, >>|9|
|&|8|
|\||7|
|=, <=>, >=, >, <=, <, <>, !=, IS, LIKE, REGEXP, IN|6|
|BETWEEN, CASE,WHEN,THEN,ELSE|5|
|NOT|4|
|&&, AND| 3 |
|\|\|, OR, XOR|2|
|:=|1|

* 1.2 圆括号 (...):
    * select 1+2*3; # 7
    * select (1+2)*3; # 9

* 1.3 比较函数和操作符:
    * 1 比较函数的`结果`: 1(TRUE), 0(FALSE), NULL;
    * 2 将字符串转换为数字:
        * select 1 > '6x'; # 0
        * select 7 > '6x'; # 1
        * select 0 > 'x6'; # 0
        * select 0 = 'x6'; # 1, 任何非数字字符串转为数字时, 值为0
    * 3 `= 等于`:
        * select 1 = 0;         # 0
        * select '0' = 0;       # 1
        * select '0.0' = 0;     # 1
        * select '0.01' = 0;    # 0
        * select '.01' = 0.01;  # 1
    * 4 `<=> NULL-safe equal`
        * 解释: 这个操作符和=操作符执行相同的比较操作，不过在两个操作码均为NULL时，其所得值为1而不为NULL，而当一个操作码为NULL时，其所得值为0而不为NULL.
        * select 1<=>1, NULL<=>NULL, 1<=>NULL; # 1, 1, 0
        * select 1 = 1, NULL = NULL, 1 = NULL; # 1, NULL, NULL
    * 5 `<> != 不等于`
        * select '.01' <> '0.01'; # 1
        * select .01 <> '0.01';   # 0
        * select 'zapp' <> 'zappp'; # 1
    * 6 `< <= > >=`
    * 7 `IS boolean_value` 和 `IS NOT boolean_value`
        * 这里布尔值: TRUE、FALSE、UNKNOWN
        * select 1 IS TRUE, 0 IS FALSE, NULL IS UNKNOWN; # 1, 1, 1
        * select 1 IS NOT UNKNOWN, 0 IS NOT UNKNOWN, NULL IS NOT UNKNOWN; # 1, 1, 0
        * select 'a' is true, 'a' is false, 'a' is unknown; # 0, 1, 0
    * 8 `expr BETWEEN min AND max` 和 `expr NOT BETWEEN min AND max`
        * 注意: min <= expr and expr <= max
        * select 1 BETWEEN 2 AND 3;         # 0
        * select 'b' BETWEEN 'a' AND 'c';   # 1
        * select 2 BETWEEN 2 AND '3';       # 1
        * select 2 BETWEEN 2 AND 'x-3';     # 0
    * 9 `COALESCE(value, ...)`:
        * 返回值: 为列表当中的第一个非NULL值; 在没有非NULL值是返回NULL;
        * select COALESCE(NULL, 1), COALESCE(NULL, NULL, NULL); # 1, NULL
    * 10 `GREATEST(value1, value2, ...)` 和 `LEAST(value1, ...)`
        * 解释: GREATEST当有2个以上参数时，返回最大的参数;
        * slect GREATEST(2, 0, 1), GREATEST('B', 'A', 'C'); # 2, 'C'
    * 11 `expr IN (value, ...)`
        * 若expr 为IN列表中的任意一个值，则其返回值为 1 , 否则返回值为0。假如所有的值都是常数，则其计算和分类根据 expr 的类型进行。这时，使用二分搜索来搜索信息。如IN值列表全部由常数组成，则意味着IN 的速度非常之快。如expr 是一个区分大小写的字符串表达式，则字符串比较也按照区分大小写的方式进行。
        * select 2 IN (0, 3, 5, 'wef');  # 0
        * select 'wef' IN (0, 3, 'wef'); # 1
    * 12 `ISNULL(expr)`
        * select ISNULL(1+1), ISNULL(1/0); # 0, 1
    * 13 `INTERVAL(N, N1, N2, ...)`
        *  假如N < N1，则返回值为0；假如N < N2 等等，则返回值为1；假如N 为NULL，则返回值为 -1 。所有的参数均按照整数处理。为了这个函数的正确运行，必须满足 N1 < N2 < N3 < ……< Nn 。其原因是使用了二分查找(极快速)。
        * select INTERVAL(23, 1, 15, 17, 30, 44);   # 3
        * select INTERVAL(10, 1, 10, 100, 1000);    # 2
        * select INTERVAL(22, 23, 30, 44, 200);     # 0

* 1.4 逻辑操作符:
    * 1 `NOT !`:
        * select NOT 10, NOT 0, !(1+1), ! 1+1; # 0, 1, 0, 1
    * 2 `AND &&`:
        * select 1&&1, 1&&0, 1&&NULL, 0&&NULL, NULL&&0; # 1, 0, NULL, 0, 0
    * 3 `OR ||`:
        * select 1 || 1, 1||0, 0||0, 0||NULL, 1||NULL;  # 1, 1, 0, NULL, 1
    * 4 `XOR`:
        * 当任意一个操作数为 NULL时，返回值为NULL。对于非 NULL 的操作数，假如一个奇数操作数为非零值，则计算所得结果为 1 ，否则为 0 。
        * select 1 XOR 1, 1 XOR 0;  # 0, 1
        * select 1 XOR NULL;        # NULL
        * select 1 XOR 1 XOR 1;     # 1

### 二、控制流程函数
* 1 `CASE WHEN THEN ELSE END` 语句

```
    CASE value
        WHEN [compare-value] THEN result
        [ WHEN [compare-value] THEN result ] ...
        [ ELSE result]
    END

    -- 在第一个方案的返回结果中， value=compare-value。而第二个方案的返回结果是第一种情况的真实结果。如果没有匹配的结果值，则返回结果为ELSE后的结果，如果没有ELSE 部分，则返回值为 NULL。

    -- 栗子1
    select 
      case 1 
        when 1 then 'one'
        when 2 then 'two'
        else 'more'
      end; # 'one'

    -- 栗子2
    select
      case
        when 1>0 then 'true'
        else 'false'
      end; # 'true'
    
    -- 栗子3
    select
      case BINARY 'B'
        when 'a' then 1
        when 'b' then 2
      end;

    -- 栗子4
    update movie_table
    set category = 
      case 
        when drama = 'T' then 'drama'
        when comedy = 'T' then 'comedy'
        when cartoon = 'T' and rating = 'G' then 'family'
        else 'mise'
      end;
```

* 2 `IF` 语句

```
Syntax:
    IF (expr1, expr2, expr3) 
    -- 如果expr1是TRUE(expr1<>0 and expr1<>NULL), 返回expr2; 否则返回expr3
    -- IF()的返回值为数字之或字符串值。。。

    -- 栗子: select IF (1>2, 2, 3); # 3
    -- 栗子: select IF (1<2, 'yes', 'no'); # 'yes'
    -- 栗子: select IF (STRCMP('test', 'test1'), 'no', 'yes'); # 'no'

    注意:
    -- 栗子: select IF ('a', true, false); # false
    -- 栗子: select IF ('123', true, false); # true
    -- 栗子: select IF (123, true, false); # true
```

* 3 `IFNILL` 语句

```
Syntax:
    IFNULL(expr1, expr2)
    --  假如expr1 不为 NULL，则 IFNULL() 的返回值为 expr1; 否则其返回值为 expr2。IFNULL()的返回值是数字或是字符串，
    
    -- 栗子
    1. select IFNULL(1, 0); # 1
    2. select IFNULL(NULL, 10); -- 10
    3. select IFNULL(1/0, 10);  -- 10
    4. select IFNULL(1/0, 'yes'); -- 'yes';
```

* 4 `NULLIF` 语句

```
Syntax:
    NULLIF(expr1, expr2)
    -- 如果expr1 = expr2 成立，那么返回值为NULL，否则返回值为 expr1。这和CASE WHEN expr1 = expr2 THEN NULL ELSE expr1 END相同。

    -- 栗子
    1. select NULLIF(1, 1), NULLIF(2, 3); # NULL, 2
```

### 三、字符串函数
* 1 `ASCII(str)`

```
Syntax:
    ASCII(str)
    -- 返回值为字符串str 的最左字符的数值。假如str为空字符串，则返回值为 0 。假如str 为NULL，则返回值为 NULL。 ASCII()用于带有从 0到255的数值的字符

    -- 栗子
    1. SELECT ASCII('2'), ASCII(2), ASCII('dx'); # 50, 50, 100
```

* 2 `BIN(N)`

```
Syntax:
    BIN(N)
    --  返回值为N的二进制值的字符串表示，其中 N 为一个longlong (BIGINT) 数字。这等同于 CONV(N,10,2)。假如N 为NULL，则返回值为 NULL。

    -- 栗子
    1. select BIN(12); # '1100'
```

* 3 `BIT_LENGTH(str)`   # 二进制的字符串的长度
* 4 `LENGTH(str)`       # 字符串长度
* 5 `CHAR(N1, N2... [USING charset])` -- 将每个参数N理解为一个证书，返回整数的字符
    * select CHAR(77, 121, 83, 81, '76'), CHAR(77, 77.3, '77.3'); # 'MYSQL', 'MMM'
* 6 `HEX`
    * select HEX(255), HEX('abc'), 0x616263; -- 'FF', 616263, 'abc'
* 7 `CONCAT(str1, str2, ...)`
    * select CONCAT('My', 'S', 'QL'); -- 'MySQL'
    * select CONCAT('My', NULL, 'QL'); -- NULL
    * select CONCAT(14.3); -- 14.3

* 8 `CONV` 禁止转换

```
Syntax:
    CONV(N, from_base, to_base);
    -- 不同数基间转换数字。返回值为数字的N字符串表示，由from_base基转化为 to_base 基。如有任意一个参数为NULL，则返回值为 NULL。自变量 N 被理解为一个整数，但是可以被指定为一个整数或字符串。最小基数为 2 ，而最大基数则为 36。 If to_base 是一个负数，则 N 被看作一个带符号数。否则， N 被看作无符号数。 CONV() 的运行精确度为 64比特。

    -- 栗子
    -- 1. 二进制 -> 十进制
    select conv(1010, 2, 10), conv('1010', 2, 10); # 10, 10

    -- 2. 十进制 -> 二进制
    select conv(10, 10, 2); # 1010

    -- 3 十六进制 -> 二进制
    select conv('a', 16, 2); # '1010'

    -- 4 十八进制 -> 八进制
    select conv('6E', 18, 8); # '172'

    -- 5 带符号
    select conv(-17, 10, -18); # '-H'

    -- 6
    select conv(10+'10'+'10'+0xa, 10, 10); # 40
```

* 9 `ELT` 语法

```
Syntax:
    ELT(N, str1, str2, str3, ...)
    --  若N = 1，则返回值为 str1 ，若N = 2，则返回值为 str2 ，以此类推。 若N 小于1或大于参数的数目，则返回值为 NULL 。 ELT() 是 FIELD()的补数。

    -- 栗子
    1. select ELT(1, 'ej', 'Heja', 'hej', 'foo'); # 'ej'
    2. select ELT(4, 'ej', 'Heja', 'hej', 'foo'); # 'foo'
```

* 10 `FIELD` 语法

```
Syntax:
    FIELD(str, str1, str2, str3, ...)
    -- 返回值为str1, str2, str3,……列表中的str 指数。在找不到str 的情况下，返回值为 0 。 如果所有对于FIELD() 的参数均为字符串，则所有参数均按照字符串进行比较。如果所有的参数均为数字，则按照数字进行比较。否则，参数按照双倍进行比较。 如果str 为NULL，则返回值为0 ，原因是NULL不能同任何值进行同等比较。FIELD() 是ELT()的补数。

    -- 栗子
    slect FIELD('ej', 'Hej', 'Heja'); # 2
    select FIELD('e', 'Hej', 'Foo'); # 0
```

* 11 `FIND_IN_SET` 语法

```
Syntax:
    FIND_IN_SET(str, strlist)
    --  假如字符串str 在由N 子链组成的字符串列表strlist 中， 则返回值的范围在 1 到 N 之间 。一个字符串列表就是一个由一些被‘,’符号分开的自链组成的字符串。如果第一个参数是一个常数字符串，而第二个是type SET列，则 FIND_IN_SET() 函数被优化，使用比特计算。如果str不在strlist 或strlist 为空字符串，则返回值为 0 。如任意一个参数为NULL，则返回值为 NULL。 这个函数在第一个参数包含一个逗号(‘,’)时将无法正常运行。

    -- 栗子
    select FIND_IN_SET('b', 'a,b,c,d'); # 2
```

* 12 `INSERT` 语法

```
Syntax:
    INSERT(str, pos, len, newstr)
    -- 返回字符串 str, 其子字符串起始于 pos 位置和长期被字符串 newstr取代的len 字符。 如果pos 超过字符串长度，则返回值为原始字符串。 假如len的长度大于其它字符串的长度，则从位置pos开始替换。若任何一个参数为null，则返回值为NULL。

    -- 栗子
    1. select insert('Quadratic', 3, 4, 'What'); # 'QuWhattic'
    2. select insert('Quadratic', -1, 4, 'What'); # 'QuaWhat'
    3. select insert('Quadratic', 3, 100, 'What'); # 'QuaWhat'
```

* 13 `INSTR` 语法

```
Syntax:
    INSRT(str, substr)
    -- 返回字符串 str 中子字符串的第一个出现位置。这和LOCATE()的双参数形式相同，除非参数的顺序被颠倒。

    -- 栗子
    1. SELECT INSTR('foobarbar', 'bar'); # 4
    2. SELECT INSTR('xbar', 'foobar'); # 0
```

* 14 `LEFT(str, len)`: 返回从字符串str开始的len最左字符
    * select LEFT('foobarbar', 5); # 'fooba'
    * `RIGHT(str, len)`

* 15 `LOCATE` 语法

```
Syntax:
    LOCATE(substr, str);
    LOCATE(substr, str, pos);
     -- 第一个语法返回字符串 str中子字符串substr的第一个出现位置。第二个语法返回字符串 str中子字符串substr的第一个出现位置, 起始位置在pos。如若substr 不在str中，则返回值为0。

     -- 栗子
     1. select LOCATE('bar', 'foobarbar'); # 4
     2. select LOCATE('xbar', 'foobarbar'); # 0
     3. select LOCATE('bar', 'foobarbar', 5); # 7
```

* 16 `LOWER` 和 `UPPER` 语法

```
Syntax:
    LOWER(str) -- 返回字符串 str 以及所有根据最新的字符集映射表变为小写字母的字符 (默认为 cp1252 Latin1)
    UPPER(str) --

    -- 栗子
    1. select LOWER('QUADRATICALLY'); # 'quadratically'
    2. select UPPER('aaa'); # 'AAA'
```

* 17 `LTRIM` `TRIM` `RTRIM` 语法

```
    LTRIM(str)  -- 去字符串左边空格
    TRIM(str)   -- 去字符串两边空格
      - TRIM([{BOTH | LEADING | TRAILING} [remstr] FROM] str)
      -- 返回字符串 str ， 其中所有remstr 前缀和/或后缀都已被删除。若分类符BOTH、LEADIN或TRAILING中没有一个是给定的,则假设为BOTH 。 remstr 为可选项，在未指定情况下，可删除空格。
    RTRIM(str)  -- 去字符串右边字符

    -- 栗子
    set @str = '  ab c  ';
    select LTRIM(@str); -- 'ab c  '
    select TRIM(@str);  -- 'ab c'
    select RTRIM(@str); -- '  ab c'

    select TRIM(BOTH 'x' FROM 'xxxbarxx'); # 'bar'
    select TRIM(TRAILING 'xyz' FROM 'barxxyz'); # 'barx'
    select TRIM(LEADING 'xyz' FROM 'xxxbarxxx'); # 'barxxx'
```

* 18 `OCT` 和 `ORD`
    * OCT(N); --  返回一个 N的八进制值的字符串表示，其中 N 是一个longlong (BIGINT)数
        * == CONV(N, 10, 8);
    * ORD(N); -- 若字符串str 的最左字符是一个多字节字符，则返回该字符的代码， 代码的计算通过使用以下公式计算其组成字节的数值而得出: (1st byte code) (2nd byte code × 256) (3rd byte code × 2562) ... 假如最左字符不是一个多字节字符，那么 ORD()和函数ASCII()返回相同的值。


* 19 `REPEAT`

```
Syntax:
    REPEAT(str, count);
    -- 返回一个由重复的字符串str 组成的字符串，字符串str的数目等于count 。 若 count <= 0,则返回一个空字符串。若str 或 count 为 NULL，则返回 NULL 。

    -- 栗子
    select REPEAT('MySQL', 3); -- 'MySQLMySQLMySQL'
```

* 20 `REPLACE`

```
Syntax:
    REPLACE(str, from_str, to_str)
    -- 返回字符串str 以及所有被字符串to_str替代的字符串from_str 。

    -- 栗子
    select replace('I hate you', 'hate', 'love'); # 'I love you'
```

* 21 `REVERSE`

```
Syntax:
    REVERSE(str)
    -- REVERSE(str) 返回字符串 str ，顺序和字符顺序相反

    -- 栗子
    SELECT REVERSE('abc'); # 'cba'
```

* 22 `SPACE`

```
Syntax:
    SPACE(N) 返回一个由N间隔符号组成的字符串

    -- 栗子
    SELECT SPACE(6); # '      '
```

* 23 `SUBSTRING`

```
Syntax:
    SUBSTRING(str, pos [, len])
    SUBSTRING(str FROM pos [FOR len])
    -- 返回从pos到末尾或从pos开始长度为len的子串

    -- 栗子
    1. SELECT SUBSTRING('abcdefg', 5); # 'efg'
    2. SELECT SUBSTRING('abcdefg', 5, 2); # 'ef'
    3. SELECT SUBSTRING('abcdefg' from 5); # 'efg'
    4. SELECT SUBSTRING('abcdefg', -3); # 'efg'
    5. SELECT SUBSTRING('abcdefg', -4, 1); # 'd'
    6. SELECT SUBSTRING('abcdefg' FROM -4 FOR 2); # 'de'
```

* 24 `SUBSTRING_INDEX`

```
Syntax:
    SUBSTRING_INDEX(str, delim, count)
    -- 在定界符 delim 以及count 出现前，从字符串str返回自字符串。若count为正值,则返回最终定界符(从左边开始)左边的一切内容。若count为负值，则返回定界符（从右边开始）右边的一切内容。

    -- 栗子
    1. select substring_index('abcd_efg_hi', '_', 2); # 'abcd_efg'
    2. select substring_index('abcd_efg_hi', '_', -2); # 'efg_hi'
```

* 25 `STRCMP`

```
Syntax:
    STRCMP(expr1, expr2)
    --  若所有的字符串均相同，则返回STRCMP()，若根据当前分类次序，第一个参数小于第二个，则返回 -1，其它情况返回 1 。

    -- 栗子
    1. SELECT STRCMP('text', 'text2'); # -1
    2. SELECT STRCMP('text2', 'text'); # 1
    3. SELECT STRCMP('text', 'text'); # 0
```

### 四、数值函数
* 1 算数操作符

```
+ 加号: SELECT 3+5; # 8
- 减号: SELECT 3-5; # -2
- 一元减号: SELECT -2; # -2
* 乘号: SELECT 3*5; # 15
/ 除号: SELECT 3/5; # 0.60
    NULL: SELECT 102/(1-1); # NULL
DIV 整除: SELECT 5 DIV 2; # 2
```

* 2 数学函数

```
1. ABS(X) : 返回X的绝对值

2. 三角函数:
    1. COS(X): 返回X的余弦
       ACOS(X): 返回X的反余弦
    2. SIN(X): 返回X的正弦
       ASIN(X): 反正弦
    3. TAN(X): 正切
       ATAN(X): 反正切
    4. COT(X) ACOT(X)

3. 取近似:
    * 上界整数: CEILING(X) = CEIL(X); 返回不小于X的最小整数值
    * 下届整数: FLOOR(X): 返回不大于X的最大整数
    * 最接近(四舍五入): 
        * 整数: ROUND(X): X 是浮点数
        * 小数位数为D为的浮点数: ROUND(X, D)

3.1 TRUNCATE(X, D):
    * D为非负数, 则保留浮点数X的D位小数
    * D为负数, 只保留整数部分，并将|D|位整数置零
        * SELECT TRUNCATE(1.223, 1); # 1.2
        * SELECT TRUNCATE(1.999, 0); # 1
        * SELECT TRUNCATE(122.231, -2); # 100
        * SELECT TRUNCATE(-1.999, 1); # 1.9

4. CRC32(expr): 循环冗余校验值, 返回一个32比特无符号值.若参数为NULL ，则结果为 NULL。
    * SELECT CRC32('MySQL'); # 3259397556
    * SELECT CRC32('mysql'); # 2501908538

5. DEGREES(X): 返回参数X, 该参数由弧度被转化为度
    * select DEGREES(PI()); # 180
    * select DEGREES(PI() / 2); # 90

6. 指数和对数:
    * EXP(X): 返回e的X乘方后的值
        * SELECT EXP(0); # 1
    * LN(X): 返回X的自然对数, X相对于基数e的对数
        * SELECT LN(2); # 0.6931478055995
        * SELECT LN(-2); # NULL
    * LOG([B,] X): B为基数, 默认为e
        * SELECT LOG(2); # 0.6931478055995
        * SELECT LOG(2, 65536); # 16
    * LOG2(X): 以2为基数的对数
    * LOG10(X)
    * POW(X, Y) == POWER(X, Y): 返回X的Y次方结果
        * SELECT POW(2, 2); # 4

7. MOD(X, Y): 模, 返回X DIV Y的余数, 小数也起作用
    * select MOD(34.5, 4); # 1.5

8. PI(): 3.141593

9. RADIANS(X): 返回由角度X转化为弧度
    * select RADIANS(80);

10. 随机数:
    * RAND() : 返回0到1之间的浮点数
    * RAND(N): N为种子数，类似时间戳，种子数一样，则结果一样
        * 7-12之间的随机整数: SELECT FLOOR(7 + (RAND() * 6));
        * 随机顺序检索: SELECT * FROM tbl_name ORDER BY RAND();

11. SIGN(X):
    * X > 0, 返回1
    * X = 0, 返回0
    * X < 0, 返回-1

12. SQRT(X) : 返回非负数X的二次方根

```

### 五、日期和时间函数

```
1. ADDDATE = DATE_ADD:
    * ADDDATE(date, INTERVAL expr type)
    * ADDDATE(date, days): 日期DATE加上天数days后的新日期
        * SELECT ADDDATE('2001-01-02', 31); # '2001-02-02'
        * SELECT ADDDATE('2001-01-02', INTERVAL 31 DAY); # '2001-02-02'
        * SELECT ADDDATE('2001-01-02', INTERVAL 31 SECOND); # '2001-02-02 00:00:31'
    * YEAR, MONTH DAY, HOUR, MINUTE, SECOND
    * MINUTE_SECOND, DAY_SECOND, HOUR_SECOND, DAY_HOUR ...

2. ADDTIME(expr, expr2) : 将expr2加到expr，然后返回结果.
    * SELECT ADDTIME('2001-12-31 23:59:59.99999', '1 1:1:1.00002'); # '2002-01-02 01:01:01.000010'
    * SELECT ADDTIME('01:00:00.999999', '02:00:00.999998'); # '03:00:01.999997'

3. CONVERT_TZ(dt, from_tz, to_tz): 将时间日期值dt从时区from_tz到时区to_tz
    * SELECT CONVERT_TZ('2004-01-01 12:00:00', 'GMT', 'MET');
    * SELECT CONVERT_TZ('2004-01-01 12:00:00', '+00:00', '+10:00'); # '2004-01-01 22:00:00'
```

4. CURDATE() CURRENT_DATE(): 当前日期:
    * SELECT CURDATE(); # '2015-06-23'
    * SELECT CURDATE() + 0; 20150623
5. CURTIME() CURRENT_TIME(): 当前时间:
    * SELECT CURTIME(); # '10:40:05'
    * SELECT CURTIME(); # 104005

6. DATE(expr): 提取日期或时间日期表达式expr中的日期部分
    * SELECT DATE('2015-06-23 10:42:01');

7. DATEDIFF(expr1, expr2): 返回日期expr1和日期expr2相差的天数, expr1>expr2时为正
    * SELECT DATEDIFF('1981-11-26 23:45:45', '2015-06-23'); # -12262
    * SELECT DATEDIFF(ADDDATE(CURDATE(), 20), CURDATE()); # 20

8. DATE_FORMAT:

