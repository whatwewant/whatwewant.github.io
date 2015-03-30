---
layout: post
category: php
tags: [php, notes]
---
{% include JB/setup %}

## PHP 入门篇

### 1.语法
* 1. PHP代码卸载`<?php` 和 `?>`之间, 但注意后面的 `?>` 是可以省略的;
* 2. Echo 语句: 注意`php语句以 ; 结束`
  * 作用: 1. 输出字符串: echo "Hello"; 2. 输出表达式结果: echo 23+56;
* 3. 字符串: 
  * 1. 可以用单引号，也可以用双引号 "Hello" 'world'
  * 2. 把两个字符链接起来: 连接符. : echo "hi"."Cole"; (其他语言都是+)
* 4. PHP语句结束符: 分号(;)
* 5. 注释: //, 注意:　注释语句必须在<?php ?>之间

### 2. 变量
* 1. 以$开头
* 2. var\_dump 函数: 显示变量类型, 例如var\_dump($n) // 去掉 \
* 3. 变量命名规则:
    * 1. 以 $ 进行标识(开始)
    * 2. 以 `字母` 或 `下划线`开头: $name, $\_name // 去掉\, vim下md 显示问题
    * 3. 只能由`下划线`、`字母`、`数字` 和 `汉字`组成
    * 4. 不允许包含空格
    * 5. 区分大小写
* 4. 变量的数据类型:
    * 1. memory\_get\_usage() 获取当前 PHP 销号的内存
    * 2. $m1 = memory\_get\_usage(); // 当前内存:
        * $n = 123;
        * $m2 = memory\_get\_usage() - $m1; // 获取 $n 数据类型占用的内存
        * 字符串 272; 整形和浮点型272; 数组576
        * 数组: $vararray = array("123");
    * 3. 在PHP中, 支持８中原始类型，其中包括四种标量类型、两种复合类型和两种特殊类型。PHP是一门松散类型的语言，不必向PHP声明变量的数据类型，PHP会自动把变量转换为自动的数据类型。
* 5. 标量类型1: 布尔类型:
    * 两个值：　TRUE，　FALSE;
    * 不区分大小写: TRUE == true;
    * 注意: echo TRUE; 结果: 1
* 6. 标量类型2: 整型(integer):
    * 可以用十进制、八进制、十六进制、十进制
    * 八进制：数字前必须加上"0", $data_int = 0123;
    * 十六进制: "0x", $data_int = 0x1a;
* 7. 标量类型3: 浮点型
    * $num_float = 1.234; 
    * $num_float = 1.2e3; // 科学计数法, 小写e
    * $num_float = 1.0E-10; // 大写E
* 8. 标量类型４: 字符串:
    * 单引号或双引号
    * 单引号(双引号)中嵌入双引号(单引号): $say = 'A say: "I hate you.";';
    * 转移字符转移单双引号
    * 遇到 $, $var="love":
      * 双引号: 输出$var存储的字符串, 结果: love
      * 单引号: 输出'$var', 结果: $var
    * 长字符串处理:
      * 首先使用定界符表示字符串(<<<), 接着在"<<<"后提供一个标识符GOD(标识符不是固定的，自定义, 例如DOG, GO都行), 然后是字符串，　最后以GOD结束字符串;
      * 注意: <<<GOD 无空格, 并且<<<GOD 和 GOD;各独占一行

```php
$string1 = <<<GO
我有一只小毛驴，我从来也不骑。
有一天我心血来潮，骑着去赶集。
我手里拿着小皮鞭，我心里正得意。
不知怎么哗啦啦啦啦，我摔了一身泥.
GO;
```
* 9. 第一种特殊的类型: 资源(resource):
    * 资源：室友专门的函数来建立和使用。例如: 打开文件、数据连接、图形画布。我们可以对资源进行操作(创建、使用和释放)。任何资源，在不需要时应该及时释放。如果忘记释放资源，系体自动启用垃圾回收机制，在页面执行完毕后回收资源，以避免内存被消耗殆尽。
```php
<?php
$file_handle = fopen("f.txt", "r"); // 打开文件
$con = mysql_connect("localhost", "root", "root"); // 简历数据库链接
$img = imagecreate(100, 100); // 图形画布

if ($file_handle) {
  // 采用while循环读取文件
  while (!feof($file_handle)) {
    $line = fgets($file_handle);
    echo $line;
    echo "<br />";
  }
}
fclose($file_handle); // 关闭文件句柄
?>
```

* 10. 第二种特殊类型: 空类型(NULL):
    * NULL or null, 对大小写不敏感
    * 表示变量没有值, 情况:
      * 1. 赋值NULL
      * 2. 未被赋值
      * 3. unset($var),
    * `error_reporting(0); // 禁止显示PHP警告`
    
## 4. 常量:
* 1. 定义:
    * 1. 自定义常量：
      * bool define(string $constant_name, mixed $value[, $case_sensitive = true]);
      * define("PI", 3.14);echo PI;
      * $p="PII"; define($p, "123"); echo PII;
      * `echo "面积是: ".(PI*3*3);`
    * 2. 系统常量:
      * 1. __FILE__: php程序文件名, 可以帮助获取当前文件在服务器的物理位置
      * 2. __LINE__: PHP程序文件行数，　当前代码在第几行
      * 3. PHP_VERSION
      * 4. PHP_OS: 操作系统名字
* 2. 获取常量的值:
    * 1. 直接使用 PI
    * 2. mixed constant(string constant_name); // constant("PI");
* 3. 如何判断常量是否被定义:
    * 1. bool defined(string constants_name); // 存在返回true, 不存在返回false; // 例如: $exist = define("PI");
    
## 5. 运算符:
* 1. 