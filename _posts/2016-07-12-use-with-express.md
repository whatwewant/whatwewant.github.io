---
layout: post
title: "use with express"
keywords: [""]
description: ""
category: ""
tags: [""]
---
{% include JB/setup %}

### @1 Express项目文件结构
* [ExpressProjectBasicFileStructure.png](/images/.ExpressProjectBasicFileStructure.png)
* 解析
  * 1 `app.js`: 项目入口文件
  * 2 `app`: 项目目录
    * `schemas`: mongoose 数据结构
    * `models`: mongoose 模型文件
    * `controllers`: 控制器, 主要是路由动作函数
  * 3 `public`: 静态文件目录
    * `lib`: 公用静态文件，如bootstrap
    * `js`: javascript
    * `css`: css
    * `images`: images
  * 4 `config`: 项目配置目录
    * `routes.js`: 路由配置
    * `middlewares.js`: 全局中间件
  * 5 `gulp.js` + `package.json`: 项目开发配置文件
  
### @2  Express 4.x 安装
* 1 安装NPM
* 2 [使用NVM安装和管理Node](https://github.com/creationix/nvm)
* 3 安装 express
  * `npm install express --save`
* 4 [开发配置之package.json](https://docs.npmjs.com/files/package.json)

### @3 Express Hello world web server

```javascript
// app.js
var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.listen(3000, function () {
  console.log('App server listening on port 3000!');
});

// 运行Web Server
//  node app.js
```

### @4 Rest: HTTP METHODS
* 1 HTTP请求 -> 事件 -> 数据库操作
  * `GET  ->  查询  -> select`
  * `POST ->  新建  -> insert`
  * `PUT  ->  更新  -> update`
  * `DELETE ->  删除  -> delete`
* 2 常用REST的HTTP请求
  * `MANY(列表数据)`
    * `GET  -> LIST(列表)`
    * `POST -> CREATE(创建)`
  * `ONE(单一数据)`
    * `GET  -> RETRIEVE(查询)`
    * `PUT  -> UPDATE(更新)`
    * `DELETE -> DELETE(删除)/DESTROY(销毁)`
* 3 安全: 所有操作都要做好过滤，尤其是不安全操作
  * 安全操作: GET
  * 不安全操作: POST, PUT, DELETE

### @5 Express 基本路由
* `app.METHOD(PATH, HANDLER)`

```
// HTTP GET
app.get('/', function (req, res) {
  res.send('GET');
})

// HTTP POST
app.post('/', function (req, res) {
  res.send('POST');
})

// HTTP PUT
app.put('/user/sama', function (req, res) {
  res.send('PUT');
});

// HTTP DELETE
app.delete('/user/sama', function (req, res) {
  res.send('DELETE');
});
```

### @6 Express 高级路由
* 1 路由方法(METHODS)
  * `app.all(PATH, MIDDLEWARE_HANDLER)`
    * 在对PATH路径的get/post/put/delete等请求前做处理
    * MIDDLEWARE_HANDLER: 请查看 @7 Express 中间件
    * `注意区别: app.use('*', MIDDLEWARE_HANDLER);`
* 2 路由路径(PATH)
  * PATH
    * 类型: 
      * 字符串(string): `app.get('/user', ...);`
      * 字符模式(string pattern): `/user/:id`
      * 正则表达式(regular expression): `app.get(/.*\.json$/, ...);`
    * 注意: 查询字符串(`query strings`)不属于路径的一部分，如`/user/:id?_t=4545`中的`_t`
* 3 路由参数(parameters)
  * 分析: `/user/:uid/books/:bid?start=0`中的`:uid`与`:bid`
    * `params`: uid
    * `query`: start
    * `body`: POST/PUT等请求中的数据
    * `注意区分: params、query、body`
    * `注意: 斜杠不是区分params的标志, 如: /flight/:from-:to` 
  * 使用
    * req.params.uid
    * req.params.bid
    * req.params.from
    * req.params.to
* 4 路由处理函数
  * 基本形式
  * 多个中间件
    * `app.METHOD(PATH, MIDDLEWARE@1, MIDDLEWARE@2, MIDDLEWARE@3, ..., HANDLER);`

```
// 基本形式
function (req, res, next) {
  // do something
  next(); // 最后必须执行next方法，才能进入下一个中间件或者最终处理函数
}
```

* 5 路由响应方法
  * `res.send(STRING | OBJECT)`: 发送多种形式的响应，常见字符或者JSON
  * `res.json(OBJECT)`: 发送JSON响应
  * `req.jsonp(OBJECT)`: 发送JSONP响应
  * `res.status(HTTP_CODE)`: 注意: 只是设置HTTP响应CODE,没有做出响应，一般会: `res.status(400).send('Bad Request')`等
  * `res.sendStatus(HTTP_CODE)`: 设置HTTP响应CODE，并做出反应
  * `res.redirect([STATUS_CODE,] PATH)`: [设置code,并]跳转 
  * `res.render(VIEW[, LOCALS][, callback])`: 渲染视图成HTML，并发送给客户端.
  * `res.sendFile(PATH[, OPTIONS][, fn])`: 将文件以OCTET流形式发送
  * `res.end()`: 终止响应进程
  * `res.download(PATH [, FILENAME][, fn])`: 用于方便客户端进行文件下载
  
* 6 路由连锁处理: app.route()

```javascript
// REST
// MANY: LIST + CREATE
app.route('/user')
  .get(MIDDLEWAREs..., HANDLER)
  .post(MIDDLEWAREs..., HANDLER);
  
// ONE: RETRIEVE + UPDATE + DELETE
app.route('/user/:id')
  .get(MIDDLEWAREs..., HANDLER)
  .put(MIDDLEWAREs..., HANDLER)
  .delete(MIDDLEWAREs..., HANDLER);
```

* 7 express.Router类 -- 号称mini-app

```javascript
// birds.js
var express = require('express');
var router = express.Router();

// middlewares
router.use(function (req, res, next) {
  console.log('Time: ', Date.now());
  next();
});

router.get('/', function (req, res) {
  res.send('GET bird');
})

router.get('/about', function (req, res) {...});

module.exports = router;


// app.js
var birds = require('./birds');
app.use('/birds', birds); // 路径包含 /birds, /birds/about, /birds/*
```

### @7 中间件(Middleware)
