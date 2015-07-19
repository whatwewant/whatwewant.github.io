---
layout: post
title: "Java Servlet 基础"
keywords: [""]
description: ""
category: Java
tags: [Java, Servlet, JSP]
---
{% include JB/setup %}

### 一、什么是Servlet
* 1.1 定义
    * Servlet是在服务器上运行的小程序。一个Servlet就是一个Java类，并且可以通过"请求-响应"编程模型来访问这个主流在服务器内存里的Servlet程序.

### 二、Tomcat 容器等级
* 2.1 Tomcat的容器分为四个等级，Servlet的容器管理Context容器，一个Context对应一个Web工程.
* 2.2 等级:
    * 1 Tomcat -- 最外层
        * 2 Container 容器
            * 3 Engine
                * 4 HOST
                    * 5 Servlet容器
                        * 6 Context 1 + Context 2 + ... 

### 三、编写Servlet
* 3.1 继承HttpServlet
    * 1 Servlet(Interface): 三个方法: Init() service() destroy()
    * 2 GenericServlet(Abstract Class): 与协议无关的Servlet
    * 3 HttpServlet(Abstract Class): 实现Http协议的Servlet
    * 4 自定义Servlet: 一般重写(覆盖) doGet、doPost方法

* 3.2 重写doGet()或者doPost()方法

* 3.3 在web.xml中注册Servlet

```Java
// 1. 在src目录下新建包com.cole.servlet, 在servlet包下新建类HelloServlet.java
import javax.servlet.http.Servlet;
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("处理Get请求");
        // 获取浏览器输出对象
        PrintWriter out = response.getWriter();
        // 要使下一句的html标签起作用
        response.setContentType("text/html;charset=utf-8");
        // 向浏览器输出
        out.println("<font color='red'>Hello Servlet.</font>");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("处理Post请求");
        // 获取浏览器输出对象
        PrintWriter out = response.getWriter();
        // 要使下一句的html标签起作用
        response.setContentType("text/html;charset=utf-8");
        // 想浏览器输出
        out.println("<font color='blue'>Hello Servlet.</font>");
    }
}
```

```Java
// 2 在web.xml中注册Servlet
    <servlet>
        <!-- servlet-name的名字可以任意取, 当然也可以是类名 -->
        <servlet-name>HelloServlet</servlet-name>
        <!-- servlet-class的值必须是处理请求的Servlet的全路径 -->
        <servlet-class>com.cole.servlet.HelloServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <!-- servlet-name的名字必须和上面servlet中的servlet-name一样 -->
        <servlet-name>HelloServlet</servlet-name>
        <!-- 访问Servlet的路径 -->
        <url-pattern>/helloservlet</url-pattern>
    </servlet-mapping>
```

```Java
// 3. index.jsp页面
<a href="/helloservlet">Get方式请求Servlet</a>

<form action="/helloservlet" method="post">
    <input type="submit" value="Post方式请求Servlet" />
</form>
```

### 三、(2)IDE编写Servlet
* 1 src -> new -> Servlet
* 2 重写doGet()或者doPost()方法
* 3 部署servlet并运行

### 四、Servlet生命周期
* 4.1 Servlet执行流程:
    * 1 Get方式请求HelloServlet
    * 2 在web.xml中的servlet-mapping寻找url-pattern -> servel-name
    * 3 在web.xml中寻找servlet-name -> servlet-class
    * 4 找到HelloServlet类
    * 5 doGet方法

* 4.2 Servlet生命周期:
    * 1 初始化阶段,执行init(ServletConfig)方法
    * 2 响应客户端请求，调用service(Servlet Request Servlet Response)方法
        * 由service根据提交方法选择doGet或doPost方法
    * 3 关闭服务器，调用Destroy()方法

* 4.3 `Tomcat装载Servlet的三种情况`
    * 1 Servlet容器启动时自动装载某些Servlet, 实现它只需要web.xml文件中的`<servlet></servlet>`之间(的最后)添加如下代码`<load-on-startup>1</load-on-startup>`, 数字越小表示优先级越高.
    * 2 在Servlet容器启动后，客户端首次向Servlet发送请求.
    * 3 Servlet类文件被更新后，重新装载Servlet.

### 五、Servlet获取九大内置对象
* 5.1 `out`: PrintWriter类型，由response.getWriter()获得
* 5.2 `reequest`: service方法中的req参数
* 5.3 `response`: service方法中的resp参数
* 5.4 `session`: req.getSession()获得
* 5.5 `application`: getServletContext()函数
* 5.6 `exception`: Throwable
* 5.7 `page`: this
* 5.8 `pageContext`: PageContext
* 5.9 `Config`: getServletCOnfig()函数
* 5.3 Session
* 5.4 Page
* 5.6 PageContext

### 六、Servlet与表单
* request
    * `getParameter()`方法: 返回唯一值
    * `getParameterValues()`: 返回数组
* `Date`: new SimpleDateFormat(String pattern):
    * String format(Date d): 日期格式化成字符串
    * Date parse(String pattern): 字符串解析成日期
        * pattern必须与new SimpleDateFormat()中的pattern一致，否则异常

### 七、Servlet路径跳转
* request.getRequestParameter("URL").forward(request, response);
    * "URL"中的"/"为项目根目录
* response.sendRedirect("URL");
    * "URL"中的"/"为当前Servlet路径
* 1 绝对路径
    * `request.getContextPath()`: 获得上下文路径，项目的根目录
* 2 相对路径
    * response.sendRedirect(request.getContextPath() + "/test.jsp");

### 八、项目实践
* 1 DBHelper
* 2 Entity
* 3 DAO
* 4 Servlet

