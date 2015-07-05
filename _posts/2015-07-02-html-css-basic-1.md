---
layout: post
title: "DIV + CSS BASIC"
category: web
tag: [html, css, web-front]
---
{% include JB/setup %}

## 第三章 html表格应用和布局
### table
* 标签
	* tr td th
	* thead tbody tfoot (逻辑分类)
* 属性
	* 填充
		* cellspacing: 单元格与边框、单元格与单元格, cellspacing="5"
		* cellpadding: 单元格内边框与内容 cellpadding="10";
	* 跨行列(td)
		* colspan: 跨X列, colspan="2"
		* rowspan: 跨Y行
		
## 第四章 html框架
### 常用属性
#### a
* 属性
	* target: 
		* Usage: target="值"
		* 值 :
			* _blank : (当前浏览器)在新窗口打开
			* _self: 默认，覆盖当前页, 在相同的框架中打开链接文档
			* _parent: 在父框中打开 (相对iframe)
			* _top: 在整个窗口中打开被链接文档 (相对iframe)
			* framename: 在指定的框架中打开链接文档
#### iframe
* 语法
	* <iframe src="引用页地址" name="框架表示名" frameborder="边框" scrolling="no"><iframe>
* 属性
	* src : url或相对url
	* name
	* frameborder: 类似border-size
	* scrolling
	
	
## 第五章 CSS: Cascading Style Sheets(层叠样式)
### 5.0 选择器
* 标签选择器: div, p, hX, img, span, ul, li, ol, a ...
* 类选择器: class
* ID选择器: id
* 复杂选择器
    * 群组选择器: div,p,#id,.c {color:red;}
    * 后代选择器 (只对后代起作用):
        * 直接后代选择器(间接不起作用): div>p { color:red; }
        * 全部后代选择器: div p {color:red; } /*只对div内的p标签作用*/

### 5.0.1 单位: px <-> em
* px: 普通像素单位
* em: 相对于字体大小的倍数
    * 2em: 当font-size:12px时, 2em = 24px

### 5.0.2 选择器优先级
* 优先级: id > class > 标签, (...与顺序无关)

### 5.1 文本属性
* 字体、字号属性（font）
	* font
	* color: RGB Or Name
	* font-weight: 粗细(bold)
	* font-size: 字体大小
	* font-family: 字体家族
		* Value: ..
* 行距、对齐等:
	* line-height: 行高
        * 案例:
            * 居中: center { line-height: ...}
	* letter-spacing: 字符间距
	* text-align: 文本对齐
		* Value:
			* center
			* left
			* right
			* justify
			* inherit
        * 案例: 
            * li标签左对齐: li { text-align: left; /*默认左对齐*/}
	* text-decoration: 文本修饰, 下划线等
		* Value: 
			* none
			* underline
			* overline
			* line-through
			* inherit
	* white-space: 空白处理, 不换行(nowrap)
    * text-transform: 字母大小写
    * text-indent: 缩进, { text-indent: 2em;}
    * direction: 规定文本方向,书写方向
	
### 5.2 背景属性
* background:
	* background
		* background: url(images/bg.jpg) no-repeat;
        * background: yelow url(img/bg.png) no-repeat;
        * background: yelow url(img/bg.png) no-repeat fixed;
	* background-color: #ccc;
	* background-image: url(...);
	* background-repeat: 重复背景图片
		* no-repeat
		* repeat
		* repeat-x
		* repeat-y
		* round
		* space
	* background-position: 位置坐标、偏移量
		* Value: top / bottom / center / left / right
        * Syntax: 
            * background-position: 水平size 垂直size;
                * 坐标轴: x正向右, y正向下
                * background-position-x
                * background-position-y
                * 水平size:
                    * 正数: 图片右移size
                    * 负数: 图片左移size
                * 垂直size:
                    * 正数: 图片下移size
                    * 负数: 图片上移size
            * 应用:
                * 右下角: background-position: bottom right;
		        * 图标截取-背景便宜: background-position + width + height

### 5.3 列表(li)属性
* list-style (用在导航菜单去掉圆点: list-style:none;)
	* Value: 
		* none : 去掉原点
		* disc : 实心圆
		* circle : 空心圆
		* sqare : 实心正方形
		* decimal : 数字, ol默认类型
		* url()
    * 属性:
        * list-style-position : 圆圈在内或外
            * outside: 默认
            * inside
		
## 第六章 盒模型
### 6.1 立体盒模型(上至下)
* 1 内容
* 2 内边距/填充 padding
* 3 边框 border
	* border
		* border-top
		* border-right
		* border-bottom
		* border-left
	* border-color
	* border-width
	* border-style
		* Value: none / solid / dotted / dashed ;
            * double : 双虚线
            * hidden
            * groove / ridge / inset / outset : 凹
	* 例子:
		* border: 1px solid red;
		* border-right: 5px dotted blue;
		* border-style: none;
* 4 background-image
* 5 background-color
* 6 外边距/便捷 margin
	* margin
	* margin-top
	* margin-right
	* margin-bottom
	* margin-left
	* 例子
		* margin: 1px 2px 3px 4px
		* margin: 1px 2px;
		* margin: 0 auto; /*水平居中*/
		* margin-left: 10px;
		
### 6.2 元素的宽度及实际占位
* 公式
	* 盒子实际宽度/高度 = height/width + padding + border、、
	
### 6.3 浮动 float
* 浮动float
    * 效果: 脱离文档流
* 清除浮动 clear
	* 作用: 
		* 如果前一个元素存在左浮动或右浮动，则换行以区隔
		* 只对块级元素有效
	* 取值
		* right / left / both / none
* 浮动脱离文档流，导致无法撑开DIV解决:
    * 在父DIV中加入
        * 1 声明该DIV的伪类选择器divName::after (divName只是标识，泛指能找到DIV的选择器名)
        * 2 必须是block
        * 3 高度必须为0
        * 4 内容随意，但必须有
        * 5 清楚两边浮动: clear: both
        * 6 overflow: hidden;


```javascript
    divName::after {
        display: block;
        height: 0;
        content: "0";
        clear: both;
        overflow: hidden;
    }
```

### 6.4 定位 Position
* Value
    * static: Default
    * absolute: 相对于浏览器最左上角位置偏移
    * fixed: 保留位置,不随鼠标移动 
    * relative: 相对于自身原来位置偏移
* Position + z-index: z-index值大的显示在上层(表面)
    * z-index: 整数值

### 6.5 Overflow: 内容超出范围(height, width)
* Value
    * visiable
    * auto
    * hidden
    * scroll

### 6.6 Display
* Value:
    * block
    * inline-block
    * inline
    * none

## 第七章 CSS二

### 7.1 超链接 a
* 四种状态
	* a:link : 未访问过
	* a:visited : 已访问
	* a:hover : 鼠标移上状态
	* a:active : 激活选定状态
* 属性:
	* color

### 7.2 box-shadow

