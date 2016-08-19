---
layout: post
title: "Mongoose - 2 Model"
keywords: [""]
description: ""
category: "nodejs"
tags: [nodejs, mongoose, mongodb, database, nosql]
---
{% include JB/setup %}

### 一 SMD成员关系
* S(Schemas) M(Models) D(documents)
* 含义:
  * 模型(Model)是由模式(Schema)编译而来的丰富的构造器(Constructor)
  * 模型(Model)的实例就是文档(Document)，被用来从数据库存储数据

### 二 编译模式成模型

```javascript
var schema = new mongoose.Schema({name: String, size: String});
var Tank = mongoose.model('Tank', schema);
```

### 三 创建文档(Constructing Document)
* `文档是模型的实例`
* 注意:
  * `只有mongoose连接了数据库，数据才能存入MongoDB`
  * 连接
    * `mongoose.connect(URL)`
    * `mongoose.connect('localhost', 'test')`

```javascript
// construct a document
var small = new Tank({size: 'small'});
// save a document to database
small.save(function (err, tank) {
  if (err) return handleError(err);
  // saved!
});

// or
// create then save
Tank.create({size: 'small'}, function (err, tank) {
  if (err) return handleError(err);
  // saved!
});
```

### 四 查询(Querying)
* 常用方法
  * find
  * findOne
  * findById
  * findOneAndUpdate
  * findOneAndRemove
  
```javascript
// sample
Tank
  .find({size: 'small'})
  .where('createdData')
  .gt(oneYearAgo)
  .exec(callback);
```

### 五 删除(Removing)

```javascipt
// sample
Tank.remove({ size: 'large'}, function (err) {
  if (err) return hanleError(err);
  // removed!
})
```

### 六 API

#### 6.1 `$where(argument)`
* Argument Type
  * `String` or `Function`
* 意义:
  * 指定查询条件并查询

```javascript
// example
Blog
  .$where('this.username.indexof("val") !== -1')
  .exec(function (err, docs) { ... });
  
// equals
Blog
  .find({$where: javascript})
  .exec(function (err, docs) { ... });
```
  
#### 6.2 `increment()`
* 意义
  * 升级版本(versionKeys)

```
// example
Model
  .findById(id, function (err, doc) {
    doc.increment();
    doc.save(function (err) { ... });
  });
```

#### 6.3 `model(name)`
* @param name   `String`
* 意义
  * 返回另一个模型实例

```
// exmaple
var doc = new Tank
doc
  .model('User')
  .findById(id, callback);
```

#### 6.4 `remove([fn])`
* @param  fn `function`
* @return Promise
* 意义
  * 删除当前文档
  
```javascript
// example
product.remove(function (err, product) {
  if (err) return handleError(err);
  Product
    .findById(product.id, function (err, product) {
      console.log(product); // null
    });
});
```

#### 6.5 `save([options], [options.safe], [options.validateBeforeSave], [fn])`
* @param 
  * [options] <Object>
  * [options.safe] <Object>
  * [options.validateBeforeSave] <Boolean>
  * [fn] <Function>
* @return 
  * <Promise>
* 意义
  * 保存实例

```javascript
// example
product.sold = Date.now();
product.save(function (err, product, numAffected) {
  if (err) return handleError(err);
  // saved!
});
```
