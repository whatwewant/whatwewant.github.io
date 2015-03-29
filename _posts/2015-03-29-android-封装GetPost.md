---
layout: post
category: java
tags: [java, android, http, get, post]
---
{% include JB/setup %}

### 为了方便，自己封装了一个
* Google 好像有更好的，还没用起来，先用用自己封装的, 以下是源码

```java
import android.annotation.TargetApi;
import android.os.Build;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by potter on 14-12-12.
 */
public class HttpClient {
    private DefaultHttpClient httpClient;
    private HttpPost httpPost;
    private HttpGet httpGet;
    private HttpEntity httpEntity;
    private HttpResponse httpResponse;

    private String returnResult;

    private ArrayList<NameValuePair> myCookies = null;

    private String httpCookies = "";

    public static Boolean getStatus(String urlString) {
        HttpClient httpClient;
        HttpGet httpGet = new HttpGet(urlString);

        httpGet.addHeader("Accept", "application/json, text/javascript, */*; q=0.01");
        httpGet.addHeader("Accept-Encoding", "gzip,deflate,sdch");
        httpGet.addHeader("Accept-Language", "en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4");
        httpGet.addHeader("Connection", "keep-alive");
        httpGet.addHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36");
        httpGet.addHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

        httpClient = new DefaultHttpClient();
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 5000);
        HttpResponse httpResponse = null;
        try {
            httpResponse = httpClient.execute(httpGet);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            String sourceHtml = null;
            try {
                sourceHtml = EntityUtils.toString(httpResponse.getEntity());
            } catch (IOException e) {
                return false;
            }

            return sourceHtml.isEmpty() ? false : true;
        }

        return false;
    }

    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    public String get(String urlString) {
        httpGet = new HttpGet(urlString);

        if (!httpCookies.isEmpty()) {
            httpGet.setHeader("Cookie", httpCookies);

        }
        httpGet.addHeader("Accept", "application/json, text/javascript, */*; q=0.01");
        httpGet.addHeader("Connection", "keep-alive");
        httpGet.addHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36");
        httpGet.addHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

        httpClient = new DefaultHttpClient();
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 5000);

        try {
            httpResponse = httpClient.execute(httpGet);
        } catch (IOException e) {
            return null;
        }

        if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            try {
                returnResult = EntityUtils.toString(httpResponse.getEntity());
            } catch (IOException e) {
                return null;
            }
            CookieStore cookieStore = httpClient.getCookieStore();
            List<Cookie> cookies = cookieStore.getCookies();

            if (null == myCookies) {
                ArrayList<NameValuePair> tmp = new ArrayList<NameValuePair>();
                for (Cookie each : cookies) {
                    tmp.add(new BasicNameValuePair(each.getName(), each.getValue()));
                    httpCookies = "";
                    httpCookies += each.getName() + "=" + each.getValue() + "; ";
                }
                myCookies = tmp;
            }

            return returnResult;
        }

        return null;
    }

    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    public InputStream getImgInputStream(String urlString) {
        httpGet = new HttpGet(urlString);

        if (! httpCookies.isEmpty()) {
            httpGet.setHeader("Cookie", httpCookies);
        }
        httpGet.addHeader("Accept", "application/json, text/javascript, */*; q=0.01");
        //httpGet.addHeader("Accept-Encoding", "gzip,deflate,sdch");
        //httpGet.addHeader("Accept-Language", "en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4");
        httpGet.addHeader("Connection", "keep-alive");
        httpGet.addHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36");
        httpGet.addHeader("Content-Type", "application/x-www-form-urlencoded; charset=GBK");

        httpClient = new DefaultHttpClient();

        try {
            httpResponse = httpClient.execute(httpGet);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

        if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            InputStream imgStream = null;
            try {
                imgStream = httpResponse.getEntity().getContent();
            } catch (IOException e) {
                return null;
            }

            // System.out.println("In MyHttpClient getStatic");

            CookieStore cookieStore = httpClient.getCookieStore();
            List<Cookie> cookies = cookieStore.getCookies();

            if (null == myCookies) {
                ArrayList<NameValuePair> tmp = new ArrayList<NameValuePair>();
                for (Cookie each : cookies) {
                    tmp.add(new BasicNameValuePair(each.getName(), each.getValue()));
                    httpCookies = "";
                    httpCookies += each.getName() + "=" + each.getValue() + "; ";
                }
                myCookies = tmp;
            }
            return imgStream;
        }

        return null;
    }


    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    public static String getStatic(String urlString) {
        HttpGet httpGet = new HttpGet(urlString);

        httpGet.addHeader("Accept", "application/json, text/javascript, */*; q=0.01");
        // httpGet.addHeader("Accept-Encoding", "gzip,deflate,sdch");
        //httpGet.addHeader("Accept-Language", "en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4");
        httpGet.addHeader("Connection", "keep-alive");
        httpGet.addHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36");
        httpGet.addHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

        HttpClient httpClient = new DefaultHttpClient();

        HttpResponse httpResponse = null;
        try {
            httpResponse = httpClient.execute(httpGet);
        } catch (IOException e) {
            return null;
        }

        if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            String returnResult = null;
            try {
                returnResult = EntityUtils.toString(httpResponse.getEntity());
            } catch (IOException e) {
                return null;
            }
            System.out.println("In MyHttpClient getStatic" + returnResult);

            return returnResult;
        }

        return "网络错误";
    }

    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    public String post(String url, ArrayList<NameValuePair> postParams) {
        httpPost = new HttpPost(url);


        if (!httpCookies.isEmpty()) {
            httpPost.setHeader("Cookie", httpCookies);
            //System.out.println("HttpCookies: " + httpCookies);
        }

        httpPost.addHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36");
        httpPost.addHeader("Connection", "keep-alive");
        httpPost.addHeader("Accept", "application/json, text/javascript, application/x-www-form-urlencoded, */*; q=0.01");
        httpPost.addHeader("Host", "192.168.3.11:7001");
        httpPost.addHeader("Origin", "http://192.168.3.11:7001");
        httpPost.addHeader("Referer", "http://192.168.3.11:7001/QDHWSingle/login.jsp");

        try {
            httpPost.setEntity(new UrlEncodedFormEntity(postParams, HTTP.UTF_8));
        } catch (UnsupportedEncodingException e) {
            return null;
        }

        httpClient = new DefaultHttpClient();
        try {
            httpResponse = httpClient.execute(httpPost);
        } catch (IOException e) {
            return null;
        }

        if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            try {
                returnResult = EntityUtils.toString(httpResponse.getEntity());
            } catch (IOException e) {
                return null;
            }
            //System.out.println("In Http Post: " + returnResult);
            return returnResult;
        }

        return "网络请求异常，请检查网络";
    }

    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    public String post(String url) {
        httpPost = new HttpPost(url);


        if (!httpCookies.isEmpty()) {
            httpPost.setHeader("Cookie", httpCookies);
        }

        httpPost.addHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36");
        httpPost.addHeader("Connection", "keep-alive");
        httpPost.addHeader("Accept", "application/json, text/javascript, */*; q=0.01");

        httpClient = new DefaultHttpClient();
        try {
            httpResponse = httpClient.execute(httpPost);
        } catch (IOException e) {
            return null;
        }

        if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            try {
                returnResult = EntityUtils.toString(httpResponse.getEntity());
            } catch (IOException e) {
                return null;
            }
            
            return returnResult;
        }

        return "网络请求异常，请检查网络";
    }
}
```