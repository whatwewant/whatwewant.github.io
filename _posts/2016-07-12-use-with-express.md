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
* (1)组成: F(req, res, next)
  * 1 `req`: HTTP request 对象
  * 2 `res`: HTTP response 对象
  * 3 `next`: 下一个中间件(函数)
* (2)作用:
  * 1 执行任何代码
  * 2 改变(修改、增加、删除)request和response对象的的属性
  * 3 结束 request-response 循环，如`res.end([DATA])`直接响应，不再进入下一个中间件或者处理函数
  * 4 调用栈中的下一个中间件(next);
* (3)注意及FAQ:
  * 如果当前中间件不能结束`请求-响应(request-response)`循环，那么必须调用`next()`来交给下一个中间件；`否则, 请求将会被挂起, 这也是HTTP请求一直没有反应的原因之一`。
* (4)类型与使用
  * 类型
    * 1 `应用级(Application-level)`中间件
    * 2 `路由级(Router-level)`中间件
    * 3 `错误处理(Error-handling)`中间件
    * 4 `內建(Built-in)`中间件
    * 5 `第三方(Third-party)`中间件
  * `Application-level`中间件
    * 1 与`app对象`绑定的中间件叫应用级中间件, 也就是使用`app.use()`和`app.METHOD()`
    * 2 `next('route')`会忽略剩下的所有中间件，之间到最后的处理函数（区别: next() 会进入下一个中间件）。
    * 3 FAQ
      * app.use(PATH, MIDDLEWARE): 只对PATH生效
      * app.use(MIDDLEWARE): 对所有挂载路径生效
  * `Router-level`中间件
    * 1 与`router对象`绑定, 其中router = express.Router(), 也是使用`router.use()`和`router.METHOD()`
    * 2 其他与应用级中间件一致
  * `Error-handling`中间件
    * 形式: function (err, req, res, next) { ... }
    * next()不是必须执行，可以在这里报错res.end等
  * `Third-party`中间件一般是应用级或者路由级中间件
    * 常用
      * `body-parser`: 解析body
      * `cookie-parser`: 解析cookie
      * `express-session`: 保存session
      * `morgan`: 记录日志Logger
      * `connect-multiparty`: 解析文件上传
      * `server-favicon`: 处理favicon
  * `Built-in`中间件
    * `express.static(root, [options])`是唯一的內建中间件
      * root指定的目录是静态文件的根目录
      * options是可选参数
  
```javascript
// 默认的可选参数
express.static(path.join(__dirname, 'public'), {
  // dofiles确定如何对待以`.`开头的文件或目录(也就是是否显示)，
  // String类型, 可选值ignore, deny, allow，
  // 其中ignore与deny的区别是，deny以403拒绝请求隐藏文件(以.开头)，ignore会在找不到文件的时候返回404
  dofiles: 'ignore', 
  
  // 开启或禁用Etag生成标志
  // 关于Etag: http://www.sxt.cn/u/324/blog/2188
  etag: true,
  
  // 设置文件后缀，一般不用
  extensions: false,
  
  // 
  fallthrough: true,
  
  // 索引文件，一般不允许索引
  index: 'index.html',
  
  // 响应头: Last-Modified
  lastModified: true,
  
  // 响应头: Cache-Control (缓存)
  // 值: 默认是毫秒的数字0, 可以设置
  //  其他字符串值 '1d' = 86400000, '1h'=3600000, '1m'=60000, '5s'=5000
  // More: https://www.npmjs.org/package/ms
  maxAge: 0,
  
  // 默认true, 在路径是目录时跳转到/，也就是在路径后面加/
  redirect: true,
  
  // 设置静态文件响应头函数
  setHeaders: function (req, path, stat) {
    // res.set('x-timestamp', Date.now());
  }
})
```
