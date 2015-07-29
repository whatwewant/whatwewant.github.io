---
layout: post
title: "Java Web (三) 过滤器(Filter)"
keywords: [""]
description: ""
category: Java
tags: [Java, Web, Filter]
---
{% include JB/setup %}

### 一、过滤器简介
* 1 含义:
    * Web过滤器: (过滤源 + 过滤规则 + 过滤结果) 是一个服务器端的组件，它可以截取用户端的请求与响应信息,并对这些信息过滤.

### 二、过滤器的工作原理和生命周期
* 1 工作原理:
    * 过程: `用户请求 <-> 过滤器 <-> Web资源`
* 2 生命周期:
    * 过程: 
        * 1 `实例化 -> Web.xml` : 只一次
        * 2 `实例化 -> 初始化 -> init()` : 只一次
        * 3 `初始化 -> 过滤   -> doFilter()` : 每次都做
        * 4 `过滤   -> 销毁   -> destroy()`
* 3 函数:
    * 1 `init()`:
        * 这是过滤器的初始化方法，Web容器创建过滤器实例后将调用这个方法。这个方法中的FilterConfig类型参数可以读取web.xml文件中过滤器的参数.
    * 2 `doFilter()`
        * 这个方法完成时间操作。这个方法是过滤器的核心方法.当用户请求访问与过滤器关联的URL时，Web容器将先调用过滤器的doFilter方法.
        * FilterChain参数可以调用chain.doFilter方法，将请求传给下一个过滤器(或目标资源)，或利用转发、重定向将请求转发给其他资源.
    * 3 `destroy()`:
        * 销毁实例，释放资源
* 4 经典问题:
    * 1 `过滤器能改变用户请求的Web资源，即能改变用户的请求路径.`
        * 比如，没有登入，不符合要求，就直接改变请求路径.
    * 2 `过滤器不能直接返回数据，不能直接处理用户请求`

```Java
// 1. 在web.xml中注册Filter
    <filter>
        <!-- Filter Name 任意取-->
        <filter-name>LoginFilter</filter-name>
        
        <!-- 过滤器的全路径: 包名 + 类名 -->
        <filter-class>com.cole.filter.LoginFilter</filter-class>

        <!-- Filter 初始化参数, 可以省略, 也可以是零对或多 -->
        <init-param>
            <!-- Filter 描述, 可以省略 -->
            <description></description>
            <param-name>username</param-name>
            <param-value>password</param-value>
        </init-param>
    </filter>

    <!-- Filter Mapping 可以多个，多个URL地址可以匹配到一个Filter里 -->
    <filter-mapping>

        <!-- Filter Name 必须与filter中的相同 -->
        <filter-name>LoginFilter</filter-name>

        <!-- 当用户请求的URL和指定的URL匹配时，将触发过滤器-->
        <!-- URL: /* 代表任意值 -->
        <url-pattern>/login.jsp</url-pattern>

        <!-- 要过滤的类型, 可以省略, 可以是零对或多对，值为: REQUEST | INCLUDE | FORWARD | ERROR, 默认为REQUEST-->
        <dispatcher>REQUEST</dispatcher>
    </filter-mapping>
```

```Java
// 2. Filter类, src -> 右键new -> Filter 或者 新建Class继承Filter (javax.servlet.filter)
public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("服务器启动时就初始化 Filter");
        System.out.println("Filter Init");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        // 先匹配web.xml中的URL并执行filter, 
        System.out.println("Filter Start ... doFilter");

        // 再执行下一条语句，也就是访问实际URL
        filterChain.doFilter(servletRequest, servletResponse);

        // 过滤结束
        System.out.println("Filter End ... doFilter");
    }

    @Override
    public void destroy() {
        System.out.println("Filter Destroy");
    }
}
```

### 三、过滤器链(多个过滤器)
* 1 `多个过滤器的实现`
    * 误解:
        * 多个过滤器一般指(web.xml): 1.多个filter, 2.一个filter中多个url-pattern(错误认为)
        * 这里是指多个filter，每个 url-pattern 一样
    * 过程(`url-pattern`一样):
        * `用户请求 -> 过滤器1 -> 过滤器2 -> 过滤器3 -> Web资源`

* 2 `多个过滤器的执行路径/顺序`
    * 服务器会按照web.xml中过滤器定义的先后顺序组装成一条链
    * 具体:
        * `用户请求 -> 过滤器1(先filter开始，在chain.doFilter, 这里不执行filter结束, 而是执行第二个过滤器) -> 过滤器2(...) -> ... -> Servlet的Service方法 -> 过滤器n的end方法 -> ... -> 过滤器1的end方法 -> 响应用户请求`

```Java
// 1 在web.xml中注册第二个filter
    <filter>
        <filter-name>Second</filter-name>
        <filter-class>com.cole.filter.SecondFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>Second</filter-name>
        <url-pattern>/login.jsp</url-pattern>
    </filter-mapping>
```

```Java
// 2 第二个过滤器
public class SecondFilter implements Filter {
    public void destroy() {
        System.out.println("SecondFilter destroy .... ");
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        System.out.println("SecondFilter Start ... doFilter" + new Date());
        chain.doFilter(req, resp);
        System.out.println("SecondFilter End ... doFilter");
    }

    public void init(FilterConfig config) throws ServletException {
        System.out.println("SecondFilter init .");
    }

}

/* 结果
Filter Init
SecondFilter init .

Filter Start ... doFilterTue Jul 21 09:54:59 CST 2015
SecondFilter Start ... doFilterTue Jul 21 09:54:59 CST 2015
SecondFilter End ... doFilter
Filter End ... doFilter
*/
```

### 四-过滤器分类(Dispacther)(3类)
* 1 四类(Servlet 2.x) / 五类(Servlet 3.x): 默认REQUEST
    * 1 `REQUEST`: 
        * 用户直接访问页面或服务器response.sendRedirect时，Web容器将会调用过滤器
    * 2 `FORWARD`: 
        * 服务器request.getRequestDispatcher("URL").forward(request, response);
        * 目标资源通过RequestDespatcher的forward访问时，该过滤器将被调用.
        * jsp页面<jsp:forward page="URL" ></jsp:forward>
    * 3 `INCLUDE`: 
        * 目标资源是通过RequestDispatcher的include方法调用时
        * jsp页面: <jsp:include />
    * 4 `ERROR`  :
        * 目标资源是通过声明式异常处理机制调用时，过滤器将被调用
    * 5 `(Servlet 3.x) ASYNC`:
        * 支持异步处理

* 2 `ERROR` 实例:

```Java
// 过滤 404 错误自动到 Page Not Found
// 1. web.xml 注册错误页面和过滤器
    <!-- 自动跳转404 -->
    <error-page>
        <error-code>404</error-code>
        <!-- 404.html 已经存在于 web-content 目录 -->
        <location>/404.html</location>
    </error-page>

    <!-- 捕捉 404 错误， 进行操作 --> 
    <filter>
        <filter-name>Error404</filter-name>
        <filter-class>com.cole.filter.ErrorFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>Error404</filter-name>
        <!-- 所有的页面的404错误都会自动到 /404.html -->
        <!-- 只需要捕捉 /404.html 页面即可 -->
        <url-pattern>/404.html</url-pattern>
        <!-- 必须指定 dispatcher 包含 ERROR, 默认为REQUEST, 否则无法捕捉 -->
        <dispatcher>ERROR</dispatcher>
    </filter-mapping>
```

```Java
// 2. Filter Class: com.cole.servlet.ErrorFilter.java
// 创建Filter的两种方法:
//      1. 右键new -> Filter (IDE大多类似)
//      2. 新建Java Class -> 继承 Filter -> 实现init doFilter destroy方法

public class ErrorFilter implements Filter {
    public void destroy () {
        System.out.println("销毁 Filter");
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        // 将 req 强制转换为 request 之后就可以用 request的很多方法 ..
        // 比如 response.sendRedirect, 
        // 比如 request.getResquestDispatcher("URL").forward(request, response);
        // HttpServletRequest request = (HttpServletRequest) req;
        // HttpServletResponse response = (HttpServletResponse) resp;
        System.out.println("开始 doFilter");
        // chain.doFilter是放行，显示 404 页面
        chain.doFilter(req, resp);
        System.out.println("结束 doFilter");
    }

    public void init(FilterConfig config) throws ServletException {
        System.out.println("初始化 Filter");
    }
}
```

* 3 Servlet 3.0 新Filter: `@WebFilter`
    * 1 定义: `注解(@)`
        * @WebFilter 用于将一个类声明为过滤器，该注解将会在部署时被容器处理，容器根据具体的属性配置将相应的类部署为过滤器.
    * 2 @WebFilter 常用属性

|属性名|类型|描述|
|:-----|:---|:---|
| filterName | String | 指定过滤器的name属性, 等价于 <filter-name> |
| value | String [] | 该属性等价于urlPatterns属性, 但是两者不应该同时使用 (value的优先级大于 urlPatterns)|
| urlPatterns | String [] | 指定一组过滤器的URL匹配模式, 等价于<url-pattern> 标签 |
| servletNames | String [] | 指定过滤器将用于哪些Servlet.取值是@WebFilter中的name属性的取值，或者是web.xml中<servlet-name>的取值 |
| dispatcherTypes | DispatcherType | 指定过滤器的转发模式. 具体取值包括 ASYNC ERROR FORWARD INCLUDE REQUEST |
| initParams | WebInitParam[] | 指定一组初始化参数，等价于 <init-param> |
| asyncSupport | boolean | 声明过滤器是否支持异步操作模式,等价于<async-support>标签 |
| description | String | 过滤器的描述信息, 等价于 <description> |
| displayName | String | 该过滤器的现实名，通常配合工具使用，等价于<display-name> |

```Java
@WebFilter (servletNames = {"ErrorServlet"}, filterName = "Error404")

等价于

<filter>
    <filter-name>Error404</filter-name>
    <filter-class>...</filter-class>
</filter>
<filter-mapping>
    <filter-name>Error404</filter-name>
    <servlet-class>ErrorServlet</servlet-class>
</filter-mapping>
```

```Java
// WebFilter 实例
@WebFilter(filterName="MyAsyncFilter", value={"/404.html"}, 
    dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.ERROR, DispatcherType.ASYNC})
public class AsyncFilter implement Filter 
    ...
}
```

### 五、案例
* 过滤器在实际项目中的应用场景
    * 1 对用户请求进行统一认证
    * 2 编码转换
    * 3 对用户发送的数据进行过滤替换
    * 4 转换图像格式
    * 5 对响应的内容进行压缩

#### 案例一 过滤编码

```Java
// 1. Servlet 2.x/3.x web.xml
<filter>
    <filter-name>EncodingFilter</filter-name>
    <filter-class>com.cole.filter.EncodingFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>EncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

// 2. com.cole.filter.EncodingFilter.java
public class EncodingFilter implement Filter {
    public void destroy () {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        // 将request编码和response编码设置为urt-8，防止乱码
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html;charset=utf-8");
        chain.doFilter(req, resp);
    }

    public void init(FilterConfig config) throws ServletException {
    }
}
```

#### 案例二: 对用户请求进行统一认证

```Java
// 1. Servlet 2.x/3.x web.xml
<filter>
    <filter-name>LoginFilter</filter-name>
    <filter-class>com.cole.filter.LoginFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>LoginFilter</filter-name>
        // 将request编码和response编码设置为urt-8，防止乱码
    <!-- 所有管理界面必须管理员登陆 -->
    <url-pattern>/admin/*</url-pattern>
</filter-mapping>

// 2. com.cole.filter.LoginFilter.java
public class EncodingFilter implement Filter {
    public void destroy () {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        if (request.getSession().getAttribute("username") == null) {
            response.getWriter().println("<script>alert('请先登陆');window.location.href='/sign_in';</script>");
            return ;
        }
 
        chain.doFilter(req, resp);
    }

    public void init(FilterConfig config) throws ServletException {
    }
}
```

