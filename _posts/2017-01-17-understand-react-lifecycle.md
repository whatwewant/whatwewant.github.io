---
layout: post
title: "深入理解 React 生命周期(Lifecycle)"
keywords: [""]
description: "正确掌握React生命周期"
category: "FontEnd"
tags: ["FrontEnd", "React"]
---

{% include JB/setup %}

## 前言
* 1 React 用了这么久，经常遇到的问题是`setState`在这里写合适吗？
* 2 为什么`setState`写在这里造成了重复渲染多次？
* 3 为什么你的`setState`用的这么乱?
* 4 组件传入`props`是更新呢？重新挂载呢？还是怎样？
* 5 ...
* 所以整理了这篇文章。如果错误，欢迎指正。

### 一 生命周期的8个方法

#### 1 `componentWillMount()`
* 执行场景
  * 在`render()`方法之前
* 解释
  * 1 因为componentWillMount是在render之前执行，所以在这个方法中`setState`不会发生重新渲染(re-render);
  * 2 这是服务端渲染(`server render`)中唯一调用的钩子(hook);
  * 3 通常情况下，推荐用`constructor()`方法代替;

#### 2 `render()`
* 执行场景
  * 1 在`componentWillMount()`方法之后
  * 2 在`componentWillReceive(nextProps, nextState)`方法之后
* 解释
  * ==

#### 3 `componentDidMount()`
* 执行场景
  * 在`render()`方法之后
* 解释
  * 1 这个方法会在render()之后立即执行；
  * 2 这里可以对DOM进行操作，这个函数之后ref变成实际的DOM(@TODO 表述可能不清晰);
  * 3 这里可以加载服务器数据，并且如果使用了redux之类的数据服务，这里可以出发加载服务器数据的action;
  * 4 这里可以使用`setState()`方法触发`重新渲染(re-render)`;

#### 4 `componentWillReceiveProps(nextProps)`
* 执行场景
  * 在已经挂在的组件(mounted component)接收到新props时触发;
  * 简单的说是在除了第一次生命周期(componentWillMount -> render -> componentDidMount)之后的生命周期中出发;
* 解释
  * 1 如果你需要在`props`发生变化(或者说新传入的props)来更新`state`，你可能需要比较`this.props`和`nextProps`, 然后使用`this.setState()`方法来改变`this.state`;
* 注意
  * 1 React可能会在porps传入时即使没有发生改变的时候也发生重新渲染, 所以如果你想自己处理改变，请确保比较props当前值和下一次值; 这可能造成组件重新渲染;
  * 2 如果你只是调用`this.setState()`而不是从外部传入`props`, 那么不会触发`componentWillReceiveProps(nextProps)`函数；这就意味着: `this.setState()`方法不会触发`componentWillReceiveProps()`, `props`的改变或者`props`没有改变才会触发这个方法;

#### 5 `shouldComponentUpdate(nextProps, nextState)`
* 执行场景
  * 在接收到新`props`或`state`时，或者说在`componentWillReceiveProps(nextProps)`后触发 
* 解释
  * 在接收新的`props`或`state`时确定是否发生重新渲染，默认情况返回`true`，表示会发生重新渲染
* 注意
  * 1 这个方法在首次渲染时或者`forceUpdate()`时不会触发;
  * 2 这个方法如果返回`false`, 那么`props`或`state`发生改变的时候会阻止子组件发生重新渲染;
  * 3 目前，如果`shouldComponentUpdate(nextProps, nextState)`返回`false`, 那么`componentWillUpdate(nextProps, nextState)`, `render()`, `componentDidUpdate()`都不会被触发;
  * 4 `Take care`: 在未来，React可能把`shouldComponentUpdate()`当做一个小提示(hint)而不是一个指令(strict directive)，并且它返回`false`仍然可能触发组件重新渲染(re-render);
* Good Idea
  * 在React 15.3以后, `React.PureComponent`已经支持使用，个人推荐，它代替了(或者说合并了)`pure-render-mixin`，实现了`shallowCompare()`。[扩展阅读](http://www.zcfy.cc/article/why-and-how-to-use-purecomponent-in-react-js-60devs-2344.html)

#### 6 `componentWillUpdate(nextProps, nextState)`
* 执行场景
  * 在`props`或`state`发生改变或者`shouldComponentUpdate(nextProps, nextState)`触发后, 在`render()`之前
* 解释
  * 1 这个方法在组件初始化时不会被调用;
* 注意
  * 1 **千万不要在这个函数中调用`this.setState()`方法.**;
  * 2 如果确实需要响应`props`的改变，那么你可以在`componentWillReceiveProps(nextProps)`中做响应操作; 
  * 3 如果`shouldComponentUpdate(nextProps, nextState)`返回`false`，那么`componentWillUpdate()`不会被触发;

#### 7 `componentDidUpdate(prevProps, prevState)`
* 执行场景
  * 在发生更新或`componentWillUpdate(nextProps, nextState)`后
* 解释
  * 1 该方法不会再组件初始化时触发;
  * 2 使用这个方法可以对组件中的DOM进行操作;
  * 3 只要你比较了`this.props`和`nextProps`，你想要发出网络请求(nextwork requests)时就可以发出, 当然你也可以不发出网络请求;
* 注意
  * 如果`shouldComponentUpdate(nextProps, nextState)`返回`false`, 那么`componentDidUpdate(prevProps, prevState)`不会被触发;

#### 8 `componentWillUnmount()`
* 执行场景
  * 在组件卸载(unmounted)或销毁(destroyed)之前
* 解释
  * 这个方法可以让你处理一些必要的清理操作，比如无效的timers、interval，或者取消网络请求，或者清理任何在`componentDidMount()`中创建的DOM元素(elements);

#### 相关 `setState(Object/Function)`
* 解释
  * 通过事件(event handlers)或服务请求回调(server request callbacks), 触发UI更新(re-render);
* 参数
  * 1 可以是`Object`类型, 这时是异步的setState, 同时接收一个在state发生改变之后的回调, 如`this.setState(Object, callback)`, 其中callback可以是`() => { ... this.state ... }`;
  * 2 可以是`Function`类型, 这时是同步的setState, 例如: `(prevState, prevProps) => nextState`, 同步存在一定效率问题(不理解), 但是它有一个好处就是支持`Immutable`;

### 二 两种生命周期

#### 1 组件初始化
* 原因
  * `组件第一次建立`
* 触发
  * componentWillMount -> render -> componentDidMount

#### 2 组件更新 -- props change
* 原因
  * `props`发生改变
* 触发
  * componentWillReceiveProps -> shouldComponentUpdate -> componentWillUpdate -> componentDidUpdate

#### 3 组件更新 -- state change
* 原因
  * `this.setState()`使`state`发生改变
* 触发
  * shoudlComponentUpdate -> componentWillUpdate -> componentDidUpdate

#### 4 组件卸载或销毁
* 原因
  * `组件卸载或销毁`
* 触发
  * componentWillUnmount

### 三 相关链接
* 1 [Facebook: State and Lifecycle of React](https://facebook.github.io/react/docs/state-and-lifecycle.html#adding-lifecycle-methods-to-a-class)
* 2 [在React.js中使用PureComponent的重要性和使用方式](http://www.zcfy.cc/article/why-and-how-to-use-purecomponent-in-react-js-60devs-2344.html)
* 3 [React 常用面试题目与分析](https://zhuanlan.zhihu.com/p/24856035?utm_medium=social&utm_source=wechat_session)
* 4 [React入门教程 - 组件生命周期](https://fraserxu.me/2014/08/31/react-component-lifecycle/)
