---
layout: post
title: "Java Getting Started"
keywords: [""]
description: ""
category: Java
tags: [Java, JSP 基础]
---
{% include JB/setup %}

### 一、基础
* 1 八个基本数据类型
    * 1 `boolean`
    * 2 `char`
    * 3 `byte`
    * 4 `short`
    * 5 `int`
    * 6 `long`
    * 7 `float`
    * 8 `double`
* 2 数据类型:
    * float a = 3.14f; // 必须声明为3.14f, 否则3.14为double类型, 出错

### 三、面向对象基础: 
* 默认、abstract、interface、final、static
    * 抽象类 = 抽象方法public abstract + 普通方法 (抽象方法必须实现，普通方法不必)
    * 接口 (特殊的抽象类，即抽象类的方法全为抽象方法)
    * `单继承　多实现`
* 3 方法:
    * 1 值传递和址传递
        * 值传递: 传变量, 只是传变量值的拷贝
        * 址传递: 传对象, 先在栈区创建引用类型的变量，然后再在堆区创建对象属性.
    * 2 构造方法 注意:
        * 系统默认创建一个无参的构造方法； 但是如果你手动创建一个有参的构造方法，则系统不会默认创建无参的构造方法，即不能使用无参的构造方法; 若仍想使用，必须显示创建无参构造方法.
    * 3 方法重载:
        * 原则(3):
            * 在同一个类中
            * 方法名相同
            * `参数列表必须不同, 返回类型可以相同，即参数个数、或对应位置数据类型不同`
            * `注意: 参数相同但返回值类型不同不是重载`
                * 继承: `是覆盖`
                * 没有继承: `是BUG`
    * 4 可变参数:
        * Syntax: `DataType ...variable`
        * Usage: 可变参数相当于一个数组
        * 栗子

```java
// 可变参数:
public int add (int a, int ...b) {
    int sum = a;
    for (var t : b) {
        sum += t;
    }
    return sum;
}
```

* 4 封装和访问控制  
    * 1 概念: 
        * Java引入包(package)的机制，提供了类的多层命名空间，解决了类的命名冲突、类文件管理等问题.
        * 借助于包，可以将自己定义的类与其他类库中的类分开管理.
    * 2 定义包:
        * Syntax: `package pk_name;`
        * `注意`:
            * 1 package语句必须作为Java原文件的第一条非注释性语句;
            * 2 一个Java源文件只能指定一个包，即只有一条package语句;
            * 3 定义包之后，Java源文件中可以定义多个类，这些类将全部位于包内
            * 4 多个Java源文件可以定义相同的包
        * `注意2`
            * 1 在物理组织上，包的表现形式为目录
            * 2 但并不等同与手工创建目录后将类拷贝过去就行，必须保证类中代码声明包含包名与目录一直才行
            * 3 包名规范性: 公司域名反写.项目名.模块名, com.cole.proj.calendar.
    * 3 导入包 `总结`
        * 1 \* 指明导入当前包的所有类, 但不能使用'java.*' 或者 'java.*.*'这种语句来导入以java为前缀的所有包的所有类.
        * 2 一个Java源文件只能有一条package语句
        * 3 但可以有多条import语句，且package语句在import之前
    * 4 封装
        * 1 概念:
            * 封装是面向对象的特性之一，它实际上通过访问控制符来实现访问控制
        * 2 访问控制符(4):
            * private: 私有
            * 缺省: 可以被同一个包中的所有类访问
            * protected: 继承
            * public: 公开
            * 实例:
                * 类名只能用不修饰(本包可见), public, abstract, static, final来控制访问权限
                * 文档注释: /** ... */

* 5 静态成员
    * 定义:
        * Java中可以使用static关键字修饰类的成员变量和方法, 这些被static关键字修饰的成员也称为静态成员
        * 静态成员的限制级别是"类相关"的
        * 与类相关的静态成员被成员类变量或类方法
    * 调用:
        * 静态方法可以被类名直接调用: ClassName.StaticMember
    * 总结:
        * 1 公用静态变量: 一个类的静态成员会被该类所有实例对象共同使用
        * 2 类的静态变量和静态方法，在内存中只有一份，工所有对象共用，起到全局的作用.

* 6 对象数组
    * 1 基本数组的定义:
        * int [] a = new int[2]; a[0]=2; a[1]=3;
        * int [] a = new int[]{2, 3};
        * int [] a = {2, 3};
    * 2 对象数组: `ClassName[] var = new ClassName[count]`
    * 3 对象数组在内存中的存储:
        * 声明对象数组变量时，在栈区为数组的每个元素都开辟一个引用的空间, 对象数组变量也在栈区
        * 然后在堆内存为每个元素初始化对应的元素对象
        * 再把元素对象在堆内存的地址赋给栈区的每个元素

```java
    Student[] s1 = new Student[2];
    s1[0] = new Student('1');
    s1[1] = new Student('2');

    Student[] s2 = new Student[2] {
        new Student('1'),
        new Student('2')
    };

    Student[] s3 = {
        new Student('1'),
        new Student('2')
    }
```

### 四、核心类
#### 1 基本类型的封装类
* 1 封装类的概念
    * Java语言: 完全面向对象
    * 8个基本数据类型也具备对应对象.
    * 通过封装类可以把基本类型封装成对象使用.
    * 从JDK1.5开始，Java允许将基本类型的值直接赋值给对应的封装类对象

```java
// 封装类的实例
// 封装类(引用类, Reference types)转换为基本类型(Primitive types)
//      封装类型名.xxxValue() 来取得基础类型值
//          xxx指的是基本类型(Primitive Types)
int a = 10;
Integer obj = new Integer(10);
a = obj; // 自动转换
a = obj.intValue(); // 显示转换
float b = obj.floatValue();
  // boolean Boolean 
  // char   Character // *
  // byte   Byte
  // short  Short
  // int    Integer // *
  // long   Long
  // float  Float
  // double Double
```

* 2 封装类的作用
    * 1 将字符串的值转换为基本类型
        * a.直接调用封装类的构造方法, 即Xxx(String s)
        * b.调用封装类提供的parseXxx(String s)静态方法
    * 2 将基本类型转换为字符:
        * a.直接使用空字符串链接, ""+123
        * b.调用封装类提供的toString()静态方法, Integer.toString(123);
        * c.调用String类提供的valueOf()方法, String.valueOf(123);

```
// 1 字符串转为基本类型
int num1 = new Integer("10");
int num2 = Integer.parseInt("10");
```

#### 2 装箱和拆箱
* 1 定义:
    * 装箱: 是指将基本数据类型值转换为对应的封装类对象，即将栈中的数据封装成对象存到堆中的过程.
    * 拆箱: 装箱的反过程
    * 基本数据类型与其对应封装类之间能够自由进行转换，七本质是Java的自动装箱和拆箱过程.
* 2 目的:
    * 实现基本数据类型和其对应封装类之间的自动转换

```
// 装箱
Integer obj = 10;
// 装箱的隐藏过程: obj = new Integer(10);

// 拆箱
int a = obj;
```

#### 3 Object 类
* 1 介绍
    * Java基础类库：Object, String, Math等
    * Object对象类定义在java.lang包中, 是所有类的顶级父类
    * 在Java体系中，所有类直接或间接的继承了Object类.
    * 因此，任何Java对象都可以调用Object类中的方法，而且任何类型的对象都可以赋给Object类型的变量.
* 2 JDL文档和关联src源码
    * Ctrl + 鼠标左键 -> 对类名
* 3 Object类的常用方法
    * 1 equals()方法:
        * 对基本类型: == 比较两个变量值相等
        * 对(引用类型的)对象
            * == 标胶两个对象地址是否相等，即引用同一个对象
            * equals通常可以用于比较两个对象的内容是否相同
            * `注意: 由于==比较是对象的地址，所以两个对象永远不会相等, equal是比较内容，则只要内容相等即可相等`
        * 查看equals方法, Ctrl+鼠标左键
        * 自定义类，需要重写equals方法，否则用的是Object.equals
    * 2 toString()方法:
        * 在没有重写toString()方法之前
            * System.out.print(obj) 输出的是 `对象名@hashCode`
            * System.out.print(obj.toString()) 输出的是 `对象名@hashCode`
            * Object.toString 源码
                * `return this.getClass().getName() + "@" + Integer.toHexString(this.hashCode());`
        * 重写toString()方法后, 以上情况都是toString()方法的内容

| 方法 | 功能描述 |
|:---:|:--:|
| protected Object clone() | 创建并返回当前对象的副本，该方法支持对象复制|
| public boolean equals(Object) | 判断指定的对象与传入的对象是否相等|
| protected void finalize() | 垃圾回收器调用此方法来清理即将回收对象的资源|
| public final Class<?> getClass() | 返回当前对象运行时所属的类型|
| public int hashCode() | 返回当前对象的哈希代码值|
| public String toString() | 返回当前对象的字符串表示|

#### 4 String StringBuffer StringBuilder
* 1 运算顺序: 从左到右, 最后都要转换为字符串
    * "str" + 10 + 20 ==> "str1020" // 直接与字符串拼接
    * 10 + 20 + "str" ==> "30str" // 先其他类型相加，在与字符串拼接
* 2 常用方法:
    * length()
    * subString(int begin Index [, int endIndex])
    * lastIndexOf(String str [[, formIndex] ...])
    * toLowerCase() | toUpperCase()
    * String([char[] value | String s | StringBuffer bs | STringBuilder sb])
    * char charAt(int index)
    * int compareTo(String s): == return 0
    * boolean endsWith(String s)
    * `更多: Ctrl + <- ==> String`

* 3 StringBuffer 类
    * 1 StringBuffer用来创建和操作字符串对象，和String区别:
        * 1 String创建的字符串是不可变的，如果改变字符串，是在内存中创建一个新的字符串，字符串变量将引用新创建的字符串地址，而原来的字符串在内存中依然存在且内容不变，直到Java的垃圾回收系统对七进行销毁.
        * 2 StringBuffer创建的字符串是可变的,当使用StringBuffer创建一个字符串后，该字符串内容可以通过append(),insert,setCharAt()等方法改变，而字符串变量所引用的地址一直不变，最终调用它的toString()方法转换成一个String对象.
    * 2 常用方法:
        * StringBuffer( | String | int capacity | CharSequence seq)
        * length()
        * capacity() // 容量
        * append(String)
        * insert(int index, String)
        * replace(int start, int end, String str)
        * int delete(int start, int end)
        * StringBuffer reverse();
        * void setLength(int newLength)
        * `More Ctrl + <- == > StringBuffer Or JDK Doc`

* 4 StringBuilder
    * 和StringBuffer类似
    * 但是, StringBuffer是线程安全(即线程同步, synchronized)，StringBuilder没有实现线程安全
    * 因此, StringBuilder性能较好

#### 5 Scanner类
* 1 构造方法:
    * `Scanner(InputStream source [, String charsetName])`
    * 栗子:
        * `Scanner scanner = new Scanner(System.in);`
* 2 常用方法:
    * next()
    * nextInt()
    * nextFloat()
    * nextDouble()
    * hasNext[Xxx]()
    * useDelimiter(String): 设置分隔符，否则遇到空格就结束提取字符串
    * `More: Ctrl + <- ==> Scanner`

#### 6 Math and Date Class
* 1 Math提供的方法是静态的，可以直接调用Math.method()
    * abs(double a)
    * ceil(double a): 上界
    * floor(double a): 下界
    * round(double a):
    * max(doubale a, double b) <==> min
    * random(): 0-1 随机数
        * `UUID.randomUUID()`
    * `More: C-Left Or Doc`
* 2 Date
    * 1 构造方法:
        * `Date()` : Today
        * `Date(long milliSeconds)`
        * `Date(int year, int month, int date)`
        * `Date(int year, int month, int date, int hrs, int min [, int sec])`
        * `Date(String s)`
    * 2 常用方法:
        * `boolean after(Date when)`: return getMillisOf(this) > getMillisOf(when);
        * `boolean before(Date when)`

#### 7 SimpleDateFormat
* 1 构造函数
    * `public SimpleDateFormat()`
    * `public SimpleDateFormat(String pattern)`
    * `public SimpleDateFormat(String patternm Locale local)`
    * `public SimpleDateFormat(String pattern, DateFormatSymbols formatSymbols)`
* 2 常用方法:
    * public final String format(Date date)
* 3 SimpleDateFormat日期-时间格式模式参数

| 字母 | 日期或时间元素 | 表示 | 示例 |
|:----:|:---------------|:-----|:-----|
|G|Era|标志符|Text|AD|
|y|年|Year| 1996, 96|
|M|年中的月份|Month|July; Jul; 07|
|d|月中的天数|Number|10|
|H|一天中的小时数(0-23)|Number|0|
|h|am/pm中的小时数(1-12)|Number|12|
|m|小时中的分钟数|Number|30|
|s|分钟中的秒数|Number|55|
|S|毫秒数|Number|978|
|w|年中的周数|Number|27|
|W|月中的周数|Number|2|
|D|年中的天数|Number|189|
|F|月中的星期|Number|2|
|E|星期的天数|Text|Tuesday; Tue|
|a|Am/Pm标记 | Text| PM|
|k|一天中的小数数(24-1-23)|Number|24|
|K|am/pm中的小时数(1-11-0)|Number|0|
|z|时区|General|time zone|Pacific Standard Time; PST; GMT-08:00|
|Z|时区|RFC 822|time zone| -0800|

* 4 SimpleDateFormat Example

```java
Date d = new Date();

// 常用时间－日期格式:
// yyyy/MM/dd HH:mm:ss ==> 2015/07/13 14:02:15
// yyyy/MM/dd          ==> 2015/07/13
// HH:mm:ss            ==> 14:02:15
// yy-MM-dd            ==> 15-07-13

String datePattern = "yyyy/MM/dd HH:mm:ss";
SimpleDateFormat sdf = new SimpleDateFormat(datePattern);

System.out.println(sdf.format(d));
// Result: 2015/07/13 14:02:15
```

#### 8 System
* 1 构造方法:
    * 由于该类的构造方法是private的，所以无法创建该类的对象(实例化), 其内部的成员变量和成员方法都是static的，方法可以有类直接调用.
* 2 成员变量和方法:
    * 属性: 
        * in 标准输入
        * out 标准输出
        * err 标准出错
    * 方法

```java
// System类方法
// 1. arraycopy : 该方法的作用是数组拷贝，也就是将一个数组中的内容复制到另外一个数组中的指定位置，由于该方法是native方法，所以性能上比使用循环高效。
//  Syntax: public static void arraycopy(Object src, int srcPos, Object dest, int destPos, int length);
//  Example:
int [] a = {1, 2, 3, 4};
int [] b = new int[5]; // b = {0, 0, 0, 0, 0}
System.arraycopy(a, 1, b, 3, 2);
// b = {0, 0, 0, 2, 3};
```

```java
// 2. currentTimeMillis: 长整型, 返回当前计算机时间
//      应用: 计算程序运行时间
long start = System.currentTimeMillis();
for (int i=0; i<1000000000; i++) {
    int a = 0;
}
long end = System.currentTimeMillis();
long time = end - start;
```

```java
// 3. exit: 用于退出程序
//  Syntax: public static void exit(int status);
//      statue: 0 表示正常退出; 否则异常退出

// 4. gc方法: 请求系统进行垃圾回收，至于系统是否立刻回收，则取决于系统中垃圾回收算法的实现以及系统执行时的情况。
//  Syntax: public static void gc();
```

```java
// 5 getProperty方法: 获得系统属性名为key的属性对应的值
//  Syntax: public static String getProperty(String key);
// 
// 属性名           属性值
// java.version     Java版本
// java.home        Java安装目录
// os.name          操作系统名称
// os.version       操作系统(内核)版本
// user.name        用户账户名称
// user.home        家目录
// user.dir         用户当前工作目录
//
// Example:
String osName = System.getProperty("os.name");

System.out.println(
    "Java Version: " + System.getProperty("java.version") + "\n" +
    "Java Home: " + System.getProperty("java.home") + "\n" +
    "OS name: " + System.getProperty("os.name") + "\n" +
    "OS Version: " + System.getProperty("os.version") + "\n" +
    "User Name: " + System.getProperty("user.name") + "\n" +
    "User Home: " + System.getProperty("user.home") + "\n" +
    "User Dir: " + System.getProperty("user.dir")
);
```

#### 9 Runtime

### 四、核心类(二) Collection 集合
* 树形家族Collection
    * Set
        * HashSet
    * Queue
        * Deque
    * List
        * ArrayList
        * Vector
    * Map
        * HashMap

#### 4.2.1 HashSet: 是基于HashMap的key保存的HashSet元素
* `特点: 无序、不重复`
* 1 构造函数:
    * `HashSet();`: Set<String> = new HashSet<String>();
    * `HashSet(Collection<? extends E> c);`
    * `HashSet(int initialCapacity [, float loadFactor]);`
* 2 常用方法:
    * boolean add(DataType variable);
    * Iterator <E> iterator(): 返回对此 set 中元素进行迭代的迭代器。返回元素的顺序并不是特定的。
    * int size()
    * void clear();
    * boolean isEmpty()
    * boolean contains(Object o)
    * boolean remove(Object o)

```java
// 1 创建String类型的HashSet并添加元素
    Set<String> hSet = new HashSet<String>();
    hSet.add("h1");
    hSet.add("h2");
    hSet.add("h3");
    hSet.remove("h2");
    hSet.size();
    hSet.isEmpty();
    hSet.contains("h1");

// 2 迭代输出Set的值
    Iterator<String> it = hSet.iterator();
    while (it.hasNext()) {
        System.out.println(it.next());
    }
```

#### 4.2.2 ArrayList Vector
* `特点: 有序、可重复`
* 1 构造函数
    * `ArrayList()`
    * `ArrayList(Collection<? extends E> c);`
    * `ArrayList(int initialCapacity);`
* 2 常用方法:
    * boolean add([int index, ] E element);
    * void addAll(Collection<? extends E> c);
    * void clear();
    * boolean contains(Object o);
    * E get(int index);
    * int indexOf(Object o);
    * int lastIndexOf(Object o);
    * boolean isEmpty();
    * E remove(int index);
    * boolean remove(Object o);
    * protected removeRange(int fromIndex, int toIndex);
    * int size();

```java
// 1 创建ArrayList并添加元素
    List<String> aList = new ArrayList();
    aList.add("123");
    aList.add("456");
    aList.add("456");

    for (int i=0; i<aList.size(); ++i) {
        System.out.println(aList.get(i));
    }
```

#### 4.2.3 HashMap
* 1 构造函数
    * `HashMap()`
    * `HashMap(int initialCapacity [, float loadFactor])`
    * `HashMap(Map<? extends K, ? extends V> m)`
* 2 常用方法:
    * V put(K key, V value);
    * void putAll(Map<? extends K, ? extends V> m);
    * int size();
    * V get(Object key);
    * boolean isEmpty();
    * V remove(Object key);
    * Set<K> keySet(); // 获得键集合
    * Collection<V> values(); // 返回此映射所包含的值
    * boolean containsKey(Object key);
    * boolean containsValue(Object value);

```
// HashMap Sample
Map<Object, Object> map = new HashMap<Object, Object>();
        map.put("username", "gardom");
        map.put("password", "123456");
        map.put("administer", "0");

        Iterator<Object> it = map.keySet().iterator();
        while (it.hasNext()) {
            String key = (String) it.next();
            System.out.println(key + ": " +map.get(key));
        }
        
        System.out.println(map.keySet());
        System.out.println(map.values());
        System.out.println(map.size());
        System.out.println(map.hashCode());
        System.out.println(map.containsKey("username"));
        System.out.println(map.containsValue("123456"));
```
