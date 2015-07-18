---
layout: post
title: "JSP Getting Started"
keywords: [""]
description: "JSP 入门"
category: Java
tags: [Java, JSP]
---
{% include JB/setup %}

### 四、JSP内置对象
* 4.4 Session的生命周期
    * 1 创建:
        * 当客户端第一次访问某个jsp或者Servlet时候，服务器会为当前会话创建一个SessionID, 每次客户端向服务器发送请求是，都会将SessionId携带过去，服务端会对此SessionID进行校验.
    * 2 活动:
        * a. 某次会话当中通过超链接打开的新页面属于同一次会话.
        * b. 只要当前会话页面没有全部关闭，重新打开新的浏览器窗口访问同一个项目资源属于同一次会话.
        * c. 除非本次会话的所有页面都关闭后，再重新访问某个JSP或者Servlet将会创建新的会话.
            * `注意: 原有的会话依然存在，只是这个旧的SessionID仍然存在于服务端，只不过再也没有客户端携带它然后交予服务端校验。直到超时.`
    * 3 销毁: `Session的三种销毁方式`
        * a. 调用`session.invalidate()`方法
        * b. Session过期(超时)
        * c. 服务器重启

```Java
// JSP 页面 Session
<%
SimpleDateFormat sdf = new SimpleDateFormat();
// 设置session属性，在多个页面使用
session.setAttribute('username', 'admin');
session.setAttribute('password', '123456');
session.setAttribute('age', 20);

// 设置当前session最大期限，单位是秒
session.setMaxInactiveInterval(10); // 10秒钟
%>

// getCreationTime() 默认返回1970到现在的秒数
Session的创建时间: <%=sdf.format(new Date(session.getCreationTime())) %>
Session最后访问时间: <%=sdf.format(new Date(session.getLastAccessedTime())) %>
Session TTL: <%=sdf.format(new Date(session.getMaxInactiveInterval())) %>
Session的ID: <%=session.getId() %>
从Session中获取用户名: <%=session.getAttribute("username") %>

<% session.invalidate(); // 销毁当前session %>
```

* 4.4.1 Session对象
    * Tomcat默认的session超时时间`TTL`为30分钟
    * 设置超时时间有两种:
        * a. session.setMaxInactiveInterval(时间); // 单位是秒
        * b. 在web.xml配置

```Java
// 在web.xml中设置超时时间
<session-config>
    <!-- 单位是分钟,设置会话十分钟后超时 -->
    <session-timeout>10</session-timeout>
</session-config>
```

* 4.5 Application对象
    * `特点`:
        * 1 application对象实现了用户间数据的共享，可存放全局变量.
        * 2 application开始于服务器启动，终止于服务器关闭.
        * 3 在用户的前后连接或不同用户之间的连接中，可以对application对象的同一属性进行操作.
        * 4 在任何地方对application对象属性的操作，都将影响到其他用户对此的访问
        * 5 服务器的启动和关闭决定application对象的生命
        * 6 application对象是ServletContext类的实例.
    * `常用方法`:
        * `public void setAttribute(String name, Object value)`使用指定名称将对象绑定到此会话
        * `public Object getAttribute(String name)`返回与此会话中的指定名称绑定在一起的对象; 如果没有对象绑定在该名称下，则返回null
        * `Enumeration getAttributeNames()`: 返回所有可用属性名的枚举
        * `String getServerInfo()`: 返回JSP(SERVLET)引擎名及版本号

```Java
application中的属性有: <%
      Enumeration attributes = application.getAttributeNames();
      while (attributes.hasMoreElements()) {
        out.println(attributes.nextElement() + "&nbsp;&nbsp;");
      }
    %>
```

* 4.6 Page对象
    * `定义`:
        * Page对象是指当前JSP页面本身，有点像类中的this指针，它是java.lang.Object类的实例
    * `常用方法`:
        * `class getClass()`: 返回此Object的类
        * `int hashCode()`: 返回此Object的hash码
        * `boolean equals(Object obj)`: 判断是否相等
        * `void copy(Object obj)`: 将此Object拷贝到指定的Object对象中
        * `Object clone()`: 克隆此Object对象
        * `String toString()`
        * `void notify()`: 唤醒一个等待的线程
        * `void notifyAll()`: 唤醒所有等待的线程
        * `void wait(int timeout)`: 使一个线程处于等待知道timeout结束或被唤醒
        * `void wait()`: 使一个线程等待直到被唤醒

* 4.7 pageContext对象
    * `特点`:
        * pageContext对象提供了对JSP页面内所有的对象及名字空间的访问
        * pageContext对象可以访问到本页所在的session, 也可以取本页面所在application的某一属性值
        * pageContext对象相当于页面中所有功能的集大成者
        * pageContext对象的本类名也叫pageContext
    * `常用方法`:
        * `JspWriter getOut()`: 返回当前客户端响应被使用的JspWriter流(out)
        * `HttpSession getSession()`: 返回当前页中的HttpSession对象(session)
        * `Object getPage()`: 返回当前页的Page对象(page)
        * `ServletRequest getRequest()`: 返回当前页的ServletRequest对象(request)
        * `ServletResponse getResponse()`
        * `void setAttribute(String name, Object attribute)`: 设置属性和值
        * `Object getAttribute(String name, int scope)`: 在指定范围内取属性的值
        * `int getAttributeScope(String name)`: 返回某个属性的作用范围
        * `void forward(String relativeUrlPath)`: 使当前页面重导到另一个页面
        * `void include(String relativeUrlPath)`: 在当前位置包含另一文件

* 4.8 Config对象
    * `定义`:
        * config对象是在一个Servlet初始化时，JSP引擎向它传递信息用的，此信息包括Servlet初始化时所要用到的参数(通过属性名和属性值构成)以及服务器的有关信息(通过传递一个ServletContext对象), 常用方法如下:
    * `常用方法`:
        * `ServletContext getServletContext()`: 返回含有服务器相关信息的ServletContext对象
        * `String getInitParameter(String name)`: 返回初始化参数的值
        * `Enumeration getInitParameterNames()`: 返回Servlet初始化所需要参数的枚举

* 4.9 `Exception` 对象
    * 定义:
        * exception对象是一个异常对象,当一个页面在运行过程中发生了异常，就产生这个对象。如果一个JSP页面要应用此对象，就必须把isErrorPage设为true,否则无法编译。它实际上是java.lang.Throwable的对象.
    * 常用方法:
        * `String getMessage()`: 返回描述异常的信息
        * `String toString()`: 返回关于异常的简短描述信息
        * `void printStackTrace()`: 显示异常及其栈轨迹
        * `Throwable FillInStackTrace()`: 重写异常的执行栈轨迹

```Java
// 异常对象Exception
// Page 1. 当异常发生后，交给exception.jsp页面处理, 及跳转到exception.jsp页面
<%@ page ... errorPage="exception.jsp" %>

<% 
    System.out.println(100/0); // 抛出运行时异常,算数异常
%>


// Page 2. exception.jsp页面
<%@page ... isErrorPage="true" %>
异常消息: <%=exception.getMessage() %> <br>
简短消息: <%=exception.toString() %> <br>
```

* 4.10 练习登陆:
    * `request.setCharacterEncoding("utf-8");` : 防止中文乱码
    * `request.getRequestDispatcher("login_success.jsp").forward(request, response)`: 请求转发到login_success.jsp页面
    * `response.sendRedirect("login_failure.jsp")`: 请求重定向
    * `session.setAttribute("user", username)`

### 五、JavaBeans

### 六、JSP状态管理
* 6.1 HTTP协议无状态性
    * `无状态`是指，当浏览器发送请求给服务器的时候，服务器响应客户端请求。但是当同一个浏览器再次发送请求给服务器的时候，服务器并不知道它就是刚才哪个浏览器.即`服务器不会记住浏览器`.

* 6.2 保存用户状态的两大机制
    * `Session`机制
    * `Cookie`机制

* 6.3 Cookie简介
    * 是Web服务器保存在客户端的一系列文本信息.
    * 典型应用: 
        * 判断用户是否登陆
        * "购物车"处理
        * 是否记住密码
        * 浏览记录
    * 作用:
        * 对特定对象的追踪
        * 保存用户网页浏览记录与习惯
        * 简化登录
    * 缺点:
        * 容易泄露用户信息

* 6.4 Cookie的创建与使用
    * 1 `创建Cookie对象`:
        * Cookie newCookie = new Cookie(String key, Object value);
    * 2 `写入Cookie对象`:
        * response.addCookie(newCookie);
    * 3 `读取Cookie对象`:
        * Cookie[] cookies = request.getCookies();
    * 常用方法:

|方法名称|说明|
|:-------|:---|
| void setMaxAge(int expiry) | 设置cookie的有效期，以秒问单位 |
| void setValue(String value) | 在cookie创建后，对cookie进行赋值|
| String getName() | 获取cookie的名称 |
| String getValue() | 获取cookie的值 |
| int getMaxAge() | 获取cookie的有效时间,以秒为单位 |

```Java
    // JSP中使用Cookie实现记住用户名和密码功能
    // 设置请求编码
    request.setCharacterEncoding('utf-8');
    // 首页判断用户是否选择了记住登录密码
    String[] isUseCookies = request.getParameterValues("isUseCookie");
    if (isUseCookie != null && isUseCookie.length > 0) {
        // 把用户名和密码保存在Cookie对象里面
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 使用URLEncoder解决无法在Cookie中无法保存中文, java.net.*;
        // 相应的读取Cookie时要decode(attribute, charset);
        username = URLEncoder.encode(username, 'utf-8');
        password = URLEncoder.encode(password, 'utf-8');

        // 创建Cookie
        Cookie usernameCookie = new Cookie("username", username);
        Cookie passwordCookie = new Cookie("password", password);
        // 设置Cookie过期时间
        usernameCookie.setMaxAge(864000); // 10天
        passwordCookie.setMaxAge(864000);
        // 写入Cookie对象
        response.addCookie(usernameCookie);
        response.addCookie(passwordCookie);
    } else {
        // 获得Cookie对象
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
            for (Cookie c : cookies) {
                if (c.getName().equals("username") || 
                    c.getName().equals("password")) {
                    // 设置Cookie过期失效
                    c.setMaxAge(0);    
                    // 还必须添加到response, 重新保存
                    response.addCookie(c);
                }
            }
        }
    }
```

* 6.5 Session与Cookie的对比

| Session | Cookie |
|:--------|:-------|
| 在`服务器`端内存保存用户信息 | 在`客户端`保存用户信息 |
| Session中保存的是`Object`类型 | Cookie保存的是`String`类型 |
| 随会话的结束二将其存储的数据销毁 | Cookie可以`长期`保存在客户端 |
| 保存`重要`信息 | 保存`不重要`信息 |

### 七、指令与动作
* 7.1 include指令: `JSP三大指令: Page Include TagLib`
    * 语法: <%@ include file="URL" %>
* 7.2 include动作
* 7.3 include指令与include动作的区别
* 7.4 <jsp:forward> 动作
* 7.5 <jsp:param> 动作
* 7.6 <jsp:plugin> 动作
