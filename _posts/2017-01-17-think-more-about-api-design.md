---
layout: post
title: "对前后端API设计的一点思考 -- Status Code"
keywords: [""]
description: "API中的HTTP状态和业务状态"
category: "FrontEnd"
tags: ["API", "Http Status"]
---

{% include JB/setup %}

### 一、问题
* 首先，扯点大方向: API规范
  * 目前市面是规范比较多，大家都有自己的想法，这没错，但是遇到团队协作或者前后端交接的事件，各自遵循自己的规范可不见得是什么好事啊;
  * 这个问题不仅是前后端对接，甚至是前端团队成员协调，都会出现一些不认同，或者要花很多的沟通成本，这个时间浪费是没有必要的，这是初衷。
* 其次, 格式问题: 
  * 接口数据返回的格式，包括: Header + Data
    * Header: 就是常见的响应头(Response headers);
    * Data: 就是返回的接口数据，或者特定的业务数据;

### 二、Response 情况分类(2种)
* 1 `正确`
  * 响应头(Response header)
    * `status`: 200 或者 20x ([`这时: fetch的res.ok是正确的`](https://www.w3ctech.com/topic/854))
  * 主体(Body)
    * 返回正确JSON数据 (关于正确数据格式规范, 单独文章讲讲我的理解...)
* 2 `出错`
  * 响应头(Response header)
    * `status`: 400 或 40x 或 50x
  * 主体(Body)
    * 包含两个字段: `{ errcode: Number, errmsg: String }`, 其中
    * `errcode`: 为开发/业务错误码，不是Http Status Code, 一般为Http Status扩展码, 比如 Http Status 为 400 时, errcode 为 400001等
    * `errmsg` : 为开发/业务错误信息, 提示开发者或者提示用户

### 三、例子: Fetch

```javascript
// 以React + Redux + Redux-thunk 中使用fetch为例

let status, ok;
fetch(url, options)
  .then(res => {
    status = res.status; // 接下来会说说为什么用ok, 而不是用status
    ok = res.ok;
    return res.json();
  })
  .then(data => {
    if (!ok) {
      const _err = new Error(data.errmsg);
      _err.errcode = data.errcode;
      throw _err;
    }

    dispatch({ type: 'FETCH_DATA_SUCCESS', payload: data });
  })
  .catch(err => {
    dispatch({ type: 'FETCH_ERROR', payload: { errcode: err.status || 500, errmsg: err.toString() } })  
  })
```

* 你会发现上面有两个变量: `status`和`ok`, 其中`status`表示具体的Http Status Code, 而`ok`在Http Status Code为`20x`的时候是`true`。

### 四、参考
* [这个API很“迷人”——(新的Fetch API)](https://www.w3ctech.com/topic/854)
* [fetch API 简介](http://bubkoo.com/2015/05/08/introduction-to-fetch/)
* [传统 Ajax 已死，Fetch 永生](https://github.com/camsong/blog/issues/2)
