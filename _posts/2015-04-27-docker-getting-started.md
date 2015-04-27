---
layout: post
title: "docker getting started"
keywords: [""]
description: "Docker: Linux Container"
category: "linux"
tags: [linux, docker]
---
{% include JB/setup %}

## 参考
* [Docker —— 从入门到实践](http://yeasy.gitbooks.io/docker_practice/content/)
* [Docker中文教程](http://letong.gitbooks.io/docker/content/#)
* [Docker中文指南](http://richardhc.gitbooks.io/chinese_docker/content/)
* [官方 UserGuide](https://docs.docker.com/userguide/)

## Getting Started

### 1. Ubuntu 安装 Docker
* [方法一](http://letong.gitbooks.io/docker/content/install/ubuntu.html)
* [方法二](https://docs.docker.com/installation/ubuntulinux/) `推荐`
    * `wget -qO- https://get.docker.com/ | sh`

### 2. [命令集合](http://yeasy.gitbooks.io/docker_practice/content/appendix_command/README.html)
* 常用命令: docker --help 
    * 1. docker pull [OPTIONS] IMAGENAME[:TAG|@DIGEST] # 拉取名叫IMAGENAME的镜像
        * sudo docker pull ubuntu:14.04 # `:`后面的是标记
    * 2. docker run [OPTIONS] IMAGE [COMMAND] [ARG...] # 运行镜像，创建容器(容器是镜像的实例)
        * sudo docker run -i -t ubuntu:14.04
    * 3. docker images [OPTIONS] : 查看镜像
        * sudo docker images -a `查看所有镜像`
    * 4. docker ps [OPTIONS]: 查看容器状态
        * sudo docker ps
    * 5. docker build [OPTIONS] PATH|URL|- # 用Dockerfile创建自己的镜像
        * sudo docker build -t diyImageName --no-cache --rm=true . # (.是Dockerfile所在的路径)
        * sudo docker build -t diyImageName --no-cache --rm=true - < /path/to/Dockerfile
    * 6. docker login # 登陆远程服务器
    * 7. docker push [OPTIONS] NAME[:TAG] # 推送镜像到远程
        * sudo docker push whatwewant/ubuntu:14.04
    * 8. docker save [OPTIONS] IMAGE [IMAGE...] # 保存镜像到本地
        * sudo docker save -o ubuntu.tar ubuntu:14.04 
        * (如果没指定TAG, 这里是14.04, 则默认是lastest)
    * 9. docker load [OPTIONS] # 导入本地镜像
        * sudo docker load --input=ubuntu.tar
    * 10. 容器操作:
        * docker start [OPTIONS] CONTAINER [CONTAINER...]
            * sudo docker start 4e817cb70b48
            * sudo docker start containerName 
            * (docker run 用 --name=containerName 指定容器名字，　默认无名字)
        * docker stop [OPTIONS] CONTAINER [CONTAINER...]
        * docker restart [OPTIONS] CONTAINER [CONTAINER...]
* 常用选项: 这里针对 docker run
    * -p, --publish=[] : 指定端口映射, 可多次使用
        * docker run -p [HOST_IP:]HOST_PORT:CONTAINER_PORT ...
            * sudo docker run -p 8080:80 -d ubuntu:14.04
            * sudo docker run -p 8080:80 -p 127.0.0.1:2022:22 -d ubuntu:14.04
    * -P, --publish-all: 所有为所有EXPOSE的端口随机映射
        * EXPOSE 一般在Dockerfile中指定
        * EXPOSE 80, 22
    * -i, --interactive: 用户交互，建议和-t一起使用，效果更棒
        * sudo docker run -i -t ubuntu:14.04
    * -t, --tty : tty方式，伪终端:
        * sudo docker run -i -t ubuntu:14.04
    * -d, --detach: 以Daemon方式运行Container
        * sudo docker run -d ubuntu:14.04
    * -v, --volume=[]: 将本地数据(文件夹等)挂载到Container
        * docker run -v /hostAsbpathSrc:/containerAbspathSrc ...
            * sudo docker run -i -t -v /home/ubuntu/data:/data ubuntu:14.04
    * -u, --user= :  Username or UID (format: <name|uid>[:<group|gid>])
    * -w, --workdir= : 指定工作路径, 如果不存在会自动创建
        * sudo docker run -i -t -w /home/xxx/workdir ubuntu:14.04

## Dockerfile 的编写，自定义镜像

## [我的Dockerfile]({{ site.url }}/confs/Dockerfile)
