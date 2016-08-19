---
layout: post
title: "Mongoose 入门"
keywords: [""]
description: ""
category: "nodejs"
tags: [express, nodejs, mongodb, mongoose]
---
{% include JB/setup %}

### 一、基础使用

```javascript
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/test', function (err) {
  if (err) {
    console.error('Mongoose Connect Error: ', err);
  }
});

var Cat = mongoose.model('Cat', {name: String});

var kitty = new Cat({name: 'kitty'});
kitty.save(function (err, cat) {
  if (err) {
    console.error(err);
  } else {
    console.log('moew');
  }
});
```

### 二、基本教学

```javascript
// Step 1 安装
//  1 `MongoDB`和`Node.js`
//  2 `npm install mongoose`

// Step 2 使用mongoose连接mongodb
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/test', function (err) {
  console.error('MongoDB 连接出错: ', err);
});

// Step 3 使用数据库连接测试数据库
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error'));
db.on('open', function () {
  // 已连接
});

// Step 4 定义模式(Schema): 数据结构
// 模式(Schema)是一切的开始。
var kittySchema = mongoose.Schema({
  name: String
});

// Step 4 将模式编译成模型(Schema -> Model)
// 模型是创建文档(documents)的类。每一个文档(document)都具有模式(Schema)中声明的属性和行为，如静态方法(statics), 实例方法(methods), 预处理(pre)等
var Kitten = mongoose.model('Kitten', KittySchema);

// Step 5 测试实例方法
var silence = new Kitten({name: 'Silence'});
console.log(silence.name); // 'Silence'

// Step 6 增加实例方法(methods)
// 注意: 实例方法(methods)必须在mongoose.model()编译之前添加模式(Schema)
kittySchema.methods.speak = function () {
  var greeting = this.name
    ? "Meow name is " + this.name
    : "I don't have a name";
  console.log(greeting);
};

var Kitten = mongoose.model('Kitten', kittySchema);
// 现在就可以使用实例方法了
var fluffy = new Kitten({name: 'fluffy'});
fluffy.speak(); // "Meow name is fluffy."


// Step 7 (增Insert) 通过save方法，将保存实例(document)到数据库
fluffy.save(function (err, fluffy) {
  if (err) return console.error(err);
  fluffy.speak();
});

// Step 8 (查Select) 查找所有给予Kitten模型的实例
// MODEL.find(OPTIONS, callback);
Kitten.find(function (err, kittens) {
  if (err) return console.error(err);
  console.log(kittens);
});

// Step 9 模式(Schema)其他静态方法
//  findOne
//  findOneAndUpdate
//  findOneAndRemove
//  remove
//  removeOne
```
