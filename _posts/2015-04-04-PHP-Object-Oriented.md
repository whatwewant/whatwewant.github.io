---
layout: post
title: PHP 面向对象
category: php
tags: [php, Object-Oriented, OO, 面向对象]
---
{% include JB/setup %}

## 1. 面向对象(Object Oriented)基本概念
* 1. 对象的定义:
    * 世间万物皆对象: 可见和不可见之物
* 2. 对象的基本组成, 包含两部分:
    * 1. (属性，成员变量)对象的组成元素:
        * 是对象的`数据模型`，用于描述对象的数据
        * 又被称为对象的`属性`，或者对象的`成员变量`
    * 2. (方法)对象的行为:
        * 对象的`行为模型`, 用于描述对象能够做什么
        * 又被称为对象的`方法`
* 3. 对象的特点:
    * 1. 每个对象都独一无二
    * 2. 对象是体格特定事物,他的职能是完成特定功能
    * 3. 对象可以重复使用
* 4. 什么是面向对象:
    * 1. 向对象就是在编程的时候一直把对象放在心上
    * 2. 面向对象编程就是在编程的时候数据结构(数据组织方式)都通过对象的结构进行存储。:
        * 利用属性+方法存储数据
* 5. 为什么使用面向对象:
    * 1. 认识:
        * 1. (符合行为思维习惯)对象的描述方式更加贴近真实的世界，有利于大型业务的理解
        * 2. 在程序设计的过程中用对象的视角分析世界的时候能够拉近程序设计和真实世界的距离
    * 2. 实质:
        * 1. 面向对象就是把生活中要解决的问题都用对象的方式进行存储:
            * 属性 + 方法
        * 2. 对象与对象之间通过方法的调用完成互动:
            * 方法(的调用)
    * 3. 面向对象实例解析: 打篮球球员(对象) + 球员之间的互动(方法)
* 6. 面向对象的基本思路:
    * 1. 第一步: 识别对象:
        * 任何实体都可以被识别为一个对象
    * 2. 第二步: 识别对象的属性:
        * 对象里面存储的数据被识别为属性
        * 对于不同的业务逻辑，关注的数据不同，对象里面的属性也不同
    * 3. 第三步: 识别对象的行为(方法):
        * 对象自己属性数据的改变
        * 对象和外部交互
* 7. 面向对象的基本原则:
    * 1. 对象内部是高内聚的:
        * 对象只负责一项特定的职能(职能可大可小)
        * 所有对象相关的内容都封装到对象内部
    * 2. 对象对外是低耦合的: public, private, protected
        * 外部世界可以看到对象的一些属性(不是全部)
        * 外部世界可以看到对象的一些方法(并非全部)

## 2. PHP中的面向对象实践

### 1. 基本实践
* 1. 类的概念:
    * 有共同的属性和方法, 抽象的、一般的、一类的
    * 物理类聚, 具有相似属性
    * 类定义了这些相似对象拥有的相同属性和方法
    * `类是相似对象的描述，称为类的定义，是该类对象的蓝图或者原型`
    * 类的对象称为类的一个实例，具体到一个类产生的一个实际个体
    * 类的属性和方法统称为`类成员`
* 2. 实例化概念:
    * 类的实例化(Instantiate)就是通过类的定义创建一个类的对象
    * 一个类可以很多实例, 实例是给类成员附上具体的属性值或方法体
* 2.5 类的定义和实例化:
    * 可在终端执行php: php5 -f phpfile.php

```php
<?php
// 类的定义以以关键字class开始, 后面跟着类名，类名通常第一个字母大写。
// 类以中括号开始，中括号结束.
class NbaPlayer {
    // 定义属性
    public $name = "Jordan";
    public $height = "198cm";
    public $weight = "98kg";
    public $team = "Bull";
    public $playerNumber = "23";

    // 定义方法
    public function run() {
        echo "Running\n";
    }

    public function jump() {
        echo "Jumping\n";
    }
}

// 类到对象的实例化
// 类的实例化为对象使用关键字new, new之后紧跟类的名称和一对括号
$jordan = new NbaPlayer();

// 类的属性和方法的访问用: ->
// 访问公共属性
echo $jordan->name."\n";

// 访问公共方法
$jordan->run();
?>
```

* 3. 构造函数
* 4. 析构函数

```php
// 1.1 构造函数，在对象实例化时被调用
// 1.2. php 没有重载概念，所以不能同名方法
// 1.3. 构造函数出现了，实例化时必须符合类的构造函数形式，否则奔溃
function __construct($name, $weight) {
    echo "In constructor<br />";
    // $this是php里面的伪变量(我更喜欢叫它指向类自身的类变量), 表示变量自身
    // 最好使用$this->指明，否则不明确
    // 注意: $this->name 表示 类的$name变量, 错误用法: $this->$name
    //    $this->$name 是值 $name的值作为变量
    $this->name = $name;
    $this->weight = $weight;
}

// 4. 析构函数是在对象使用完时自动调用
// 4.1 先new的类实例后destroy
// 4.2 析构函数用于释放资源，例如变量，打印机等
function __destruct() {
    echo "Destroy ".$this->name."<br />";
}

// 类外,类实例$james
// 通过把变量设置为null, 可以触发析构函数的调用
$james = null;
```

* 5. 数据访问
* 6. 对象引用的概念:

```php
// 1. 引用包括: 独立引用 和　共享引用
$james1 = $james; // 也是对象引用，是独立引用
//   不准确的说当$james = null; 时本该触发__destruct(), 
// 但是$james1 = $james; 注意这也是对象引用，只是让$jame1指向$james指向的对象
// 类似指针, 对象存在一块内存区域，$james1 和 $james都指向它
// 所以,
// 准确的说: 当对象不会再被使用使，将会调用__destruct()函数

// 对象引用类似变量的别名，实际上还是一个变量，
//   当其中一个变量$james = null触发__destruct(),
//  此时其他对象引用将为未定义,不能再被使用
$james2 = &$james; // 也是是对象引用, 是共享引用
$james = null;
echo "\$james 将被已经被结束";
```

### 2. 高级实践
* 1. 对象的继承(extends):
    * 1. 共同属性和方法，继承同一个基类
    * 2. 不必再重复定义属性和方法
    * 3. 直接调用父类的方法和属性
    * 4. 子类可以修改和挑战父类定义的类成员: `重写(Overwrite)`
    * 5. 注意: protected 主要用于继承，子类可见，类外不可见
    * 6. 只能单继承，不支持多继承

```php
class Human {
    protected $name;
    ...
}
// 子类继承父类是，可以直接访问父类public和protected属性和方法
class NbaPlayer extends Human {
    ...
}
```

* 2. 对象的访问控制:
    * public : 公有的类成员，可以在任何地方被访问:
        * 定义该成员的类(自身)、该类的子类、其他类
    * protected : 受保护的类成员，可以被自身及其子类访问
    * private : 私有的类成员，职能被自身访问
* 3. Static(静态)关键字: public static $president="Me";
    * 1. 静态属性用于保存类的公有数据
    * 2. 静态方法里面只能访问静态属性
    * 3. 静态成员不需要实例化对象就可以访问
    * 4. 类的内部可以通过self或者static关键字访问
    * 5. 可以通过parent关键字访问父类静态属性和方法
    * 6. 可以通过类名在外部访问类的静态成员

```php
class NbaPlayer extends Human {
    public static $president = "David";

    public static function changePresident($newPresident) {
        // 注意，如果类内想访问静态成员属性
        //    1. 声明静态方法
        //    2. self::静态变量
        self::$president = $newPresident;
        // 访问父类静态成员
        parent::$humanStatic = $newPresident;
    }
}
// 调用静态方法
NbaPlayer::changePresident("Adam");
echo NbaPlayer::$president."<br />";
```

* 4. 重写
* 5. Final 关键字: public final 成员变量; 
    * 1. 相当于声明常量，一经定义不允许修改
    * 2. 方法支持缺省参数
    * 3. 重写Overwrite, 只要方法名一样即可，参数随意
    * 4. final class ClassName: 不允许被继承
* 6. 数据访问补充:
    * 1. parent 关键字可以访问父类中被重写的成员变量
    * 2. self关键字可以用于访问类自身的成员方法，也可以用于访问自己的静态成员和类常量；不能用于访问类自身的属性;使用常量的时候不需要在常量(const CONST-VALUE = "A";)前面添加$符号
    * 3. static 关键字用于访问类自身的静态成员，访问静态属性时需要在属性前面添加$符号;
    * const CONST\_VALUE =  "ABC";
    * self::CONST\_VALUE;
    * static::$staticValue;
* 7. 接口:
    * 接口就是把不同类的共同行为进行定义，然后在不同的类里面实现不同的功能
    * 2. interface -- implements

```php 
<?php
// interface 关键字用于定义接口
interface ICanEat {
    // 接口只包含方法的声明，不包含其他
    public  function eat ($food);
}

// implements关键字用于表示类实现某个接口
class Human implements ICanEat {
    // 实现某个接口之后，必须对接口中的所有方法定义
    public function eat($food)
    {
        // TODO: Implement eat() method.
        echo "Human is eating ".$food."<br />";
    }
}

$obj = new Human();
$obj->eat("Banana");
?>
```

  * 3. var\_dump($obj instanceof ICanEat) :
      * `可以用instanceof关键字来判断某个对象是否实现了某个接`
  * 4. interface ICanPee extends ICanEat {} : 接口可以继承接口
      * 类实现接口时，要实现接口的所有方法，包括接口继承的接口

* 8. 多态:
    * 不用类对接口的同一方的具体实现是不同的，这叫`多态`
* 9. 抽象类 abstract class:
    * 1. 接口里面的方法是没有实现的，二类里面的方法都是有实现的, 抽象类: 只有一部分要实现
    * 2. 比较:
        * abstract 用于定义抽象类，在方法前加abstract关键字，则该方法不需要实现
        * 在抽象类中可以包含普通方法
        * 继承抽象类: extends

```php
abstract class ACanEat {
    abstract public function eat($food);

    public function breath() {
        echo "Breath air<br />";
    }
}
class Human extends ACanEat {
    public function eat($food)
    {
        echo "Human eats ".$food."<br />";
    }
}

class Animal extends ACanEat {
    public function eat ($food) {
        echo "Animal eats ".$food."<br />";
    }
}
```

### 3. 特殊实践

