---
layout: post
title: "React - PropTypes and DefaultProps"
keywords: [js, react, props]
description: "React PropTypes 和 DefaultProps"
category: "FrontEnd"
tags: [js, react, props]
---
{% include JB/setup %}

### 一 PropsTypes 取值
* 1 常用
  * 1 字符串: `PropTypes.string`
  * 2 数字: `PropTypes.number`
  * 3 函数: `PropTypes.func`
  * 4 数组: `PropTypes.array`
  * 5 对象: `PropTypes.object`
  * 6 **React元素**: `PropTypes.element`
  * 7 **节点**: `PropTypes.node`
  * 8 **任意**: `PropTypes.any`

* 2 高级
  * 1 指定类型: `PropTypes.instanceOf(TYPE)`
  * 2 限定enum值之一: `PropTypes.oneOf(['foo', 'bar'])`
  * 3 限定enum类型之一: `PropTypes.oneOfType([PropTypes.string, PropTypes.array])`
  * 4 指定数组值的类型: `PropTypes.arrayOf(PropTypes.object)`
  * 5 指定对象的属性类型: `PropTypes.objectOf(PropTypes.string)`
  * 6 指定特定的对象类型: `PropTypes.shape({id: PropTypes.string, color: PropTypes.string})`

### 二 限定PropTypes类型
* `PropTypes.string.isRequired`
* `PropTypes.shape({ id: PropTypes.string.isRequired, color: PropTypes.string}).isRequired`

### 三 自定义类型

```
// 自定义格式(当不符合的时候，应该适当提示或者报错)
customPropTypes: function (props, propName, component) {
  if (!/^[0-9]/.test(props[propName])) {
    return new Error('Validation failed');
  }
}
```

### 四 defaultProps (ES2016)
* `设置默认值，但注意使用默认值时, isRequired属性将失效`

### 五 案例

```
import React, {Component, PropTypes} from 'react';

export default class Table {
  static propTypes = {
    title: PropTypes.string,
    header: PropTypes.arrayOf(PropTypes.string),
    body: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropType.oneOfType([PropType.string, PropTypes.number]).isRequired,
        name: PropTypes.string,
        value: PropTypes.number
      }).isRequired
    ),
  };

  render () {
    ....  
  }
}
```
