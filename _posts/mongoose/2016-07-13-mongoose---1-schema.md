---
layout: post
title: "mongoose   1 Schema"
keywords: [""]
description: ""
category: "nodejs"
tags: [nodejs, mongoose, express, database]
---
{% include JB/setup %}

### 一、定义
* `在Mongoose中，一切始于Schema。` 每个Schema会自动关联数据库连接，并定义文档的属性与行为。

### 二、创建一个Schema

```
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var blogSchema = new Schema({
  title: String,
  author: String,
  body: String,
  comments: [{ body: String, date: Date}],
  date: {type: Date, default: Date.now},
  hidden: Boolean,
  meta: {
    votes: Number,
    favs: Number,
  },
});
```

### 三 模式类型(SchemaTypes)
* 內建类型
  * String
  * Number
  * Date
  * Buffer
  * Boolean
  * Mixed:    `Schema.Types.Mixed`, 混合类型就是可以随意存放各种类型
  * ObjectId: `Schema.Types.ObjectId`, 每个document都有一个唯一的ObjectId类型的_id
  * Array:    `[SchemaType]`  
* 详细写法: `{type: SCHEMATYPES, ...options}`
  * options
    * 通用
    * SchemaString
    * SchemaNumber

============================

|GeneralName|Meaning|Type|Default|
|:---|:------|:---|:------|
|default|默认值|根据类型|无|
|get|getter|Function|无|
|index|设置二级索引|Boolean/String/Object|true|
|required|被需要|Boolean|false|
|select|设置是否可打印|Boolean|true|
|set|设置属性|Function|null|
|sparse|设置稀疏索引(不解)|Boolean|未知|
|text|文本索引(不解)|Boolean|未知|
|unique|属性值唯一|Boolean|false|
|validate|验证属性是否正确|Object|未知|

============================

|SchemaString|Meaning|Type|Default|
|:-----------|:------|:---|:------|
|checkRequired|.|Function|.|
|enum|枚举|Object/Array|无|
|lowercase|字母小写|Boolean|false|
|match|正则表达校验|RegExp/Object|无|
|maxlength|字符串最大长度|Number/Object|无|
|minlength|字符串最小长度|Number/Object|无|
|trim|去掉字符串两端空格|Boolean|false|
|uppercase|字母大写|Boolean|false|

============================

|SchemaNumber|Meaning|Type|Default|
|:-----------|:------|:---|:------|
|checkRequired|.|Function|.|
|max|最大值|Number/Object|无|
|min|最小值|Number/Object|无|

============================

|SchemaBoolean|Meaning|Type|Default|
|:-----------|:------|:---|:------|
|checkRequired|.|Function|.|

============================

|SchemaArray|Meaning|Type|Default|
|:-----------|:------|:---|:------|
|checkRequired|.|Function|.|



### 四 创建一个模型(Model)
* `mongoose.model()`

```
// 将Schema编译成Model, 很简单
var Blog = mongoose.model('Blog', blogSchema);
```
  
### 五 实例方法(methods)
* 属于: `documents`
* 定义
  * `模型的实例(instances)就是文档(documents)`.文档有很多內建(built-in)的实例方法，当然我们也可以自定义实例方法。

```javascript
// 创建 Schema
var animalSchema = new Schema({ name: String });

// 自定义实例方法
animalSchema.methods = {
  findSimilarTypes: function (cb) {
    return this
            .model('Animal')
            .find({type: this.type})
            .exec(cb);
  },
};

// 实例使用实例方法
var Animal = mongoose.model('Animal', animalSchema);
var dog = new Animal({name: 'dog'});

dog.findSimilarTypes(function (err, dogs) {
  console.log(dogs); // woof
});
```

### 六 静态方法(statics)
* 属于: `Schmeas`

```javascript
// 定义
animalSchema.statics = {
  findByName: function (name, cb) {
    return this
            .find({name: new RegExp(name, 'i')})
            .exec(cb); // 同 this.find(OPTIONS, CALLBACK)
  },
};

// 使用
var Animal = mongoose.model('Animal', animalSchema);
Animal.findByName('fido', function (err, animals) {
  console.log(animals);
});
```

### 七 Query方法(Query Helpers)
* 属于: `Schemas`
* 定义
  * query是mongoose链式查找API的扩展

```javascript
// 定义Query Helpers
animalSchema.query.byName = function (name) {
  return this
          .find({ name: new RegExp(name, 'i') });
};

// 使用
var Animal = mongoose.model('Animal', animalSchema);
Animal
  .find()
  .byName('fido')
  .exec(function (err, animals) {
    console.log(animals);
  });
```

### 八 索引(Indexes)
* 属于: `Schema`
* 意义:
  * MongoDB支持二级索引
  * 索引是为了提高查找速度，但会降低插入速度，因为没插入一次都要更新所有索引

```javascript
// 定义 Schema with index
var animalSchema = new Schema({
  name: String,
  type: String,
  tags: { type: [String], index: true } // field level
});

animalSchema.index({name: 1, type: -1});
```

### 九 虚拟属性(Virtulas)
* 属于: `Document`
* 定义:
  * 类似Python的@property
  
```javascript
var personSchema = new Schema({
  name: {
    first: String,
    last: String,
  }
});

// 定义
personSchema.virtuals('name.full').get(function () {
  return this.name.first + ' ' + this.name.last;
});
person.Schema.virtauls('name.full').set(function () {
  var split = name.split(' ');
  this.name.first = split[0];
  this.name.last = split[1];
});

// 使用
var Person = mongoose.model('Person', personSchema);
var p = new Person({ name: {first: 'Walter', last: 'White'} });
console.log(p.name.full);

p.name.full = 'Breaking Bad';
console.log(p.name);
```

### 十 选项(Options)
* 属于: `Schema`
* 定义:
  * `new Schema({...}, Options)`
  * 或者: `schema.set(option, value)`
  * 其中Options是一个对象
  
|Key|Meaning|Value|Default|
|:--|:------|:----|:------|
|`autoIndex`|自动一级索引|Boolean|true|
|`bufferCommands`|缓存|Boolean|true|
|`capped`|上限设置，限制一次性操作的量|Number(size)/Object{size, max, autoIndexId}|null|
|`collection`|数据库中的表名|String|默认是Schema的名字|
|`emitIndexErrors`|设置所有错误处理|Boolean|true|
|`id`|_id的virtuals|Boolean|true|
|`_id`|自动设置的ObjectId|Boolean|true|
|`minimize`|移除空对象(empty object)|Boolean|true|
|`read`|不解|不解|不解|
|`safe`|安全，包括日志、备份、过期时间等|Boolean/Object|true|
|`shardKey`|不解|不解|不解|
|`strict`|检查存入数据库的属性是否是Schema中定义的数据结构,在strict为true时, 如果不是，则不存|Boolean|true|
|`toJSON`|将mongoose实例翻译成json对象|Object|{getters: true, virtuals: false}|
|`toObject`|将mongoose实例翻译成javascript对象|Object|{getters: true, virtuals: true}|
|`typeKey`|指定type的别名，因为有时候type也是一个数据结构属性|String|'type'|
|`validateBeforeSave`|在保存实例到数据库之前验证|Boolean|true|
|`versionKey`|指定versionKey的别名|String/Boolean|'_v'|
|`timestamps`|自动增加createdAt和updatedAt属性|Boolean/Object|false|
|`useNestedStrict`|嵌套对象，嵌套是strict为false|Boolean|false|


