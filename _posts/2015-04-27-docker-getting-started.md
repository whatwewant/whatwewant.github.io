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

### 一 Ubuntu 安装 Docker
* [方法一](http://letong.gitbooks.io/docker/content/install/ubuntu.html)
* [方法二](https://docs.docker.com/installation/ubuntulinux/) `推荐`
    * `wget -qO- https://get.docker.com/ | sh`

### 二 [命令集合](http://yeasy.gitbooks.io/docker_practice/content/appendix_command/README.html)
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
    * 11. docker rm [OPTIONS] CONTAINER [CONTAINER2 ...]
        * 删除容器: sudo docker rm web
    * 12. docker rmi [OPTIONS] IMAGE [IMAGE2 ...]
        * 删除镜像: sudo docker rmi -f ubuntu
        * `删除所有本地镜像: sudo docker rmi -f $(docker ps -aq)`
    * 13. docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
        * 提交改动，类似git commit
        * 因为容器是只读的，所以不提交改动，一旦容器关闭，配置便失效了
        * 所以，建议写Dockerfile
        * Ex: sudo docker -a cole -m "Comments: Where or what change .." web
        * Ex: sudo docker -a cole -m "Comments: Where or what change .." d10c3120b4d7
    * 14. docker inspect [OPTIONS] CONTAINER|IMAGE [CONTAINER:IMAGE...]
        * 查看容器或镜像的详细信息
        * Ex: sudo docker inspect ubuntu:14.04
        * Ex: sudo docker inspect -f {{.DockerVersion}} ubuntu:14.04
        * Ex: sudo docker inspect -f {{.ContainerConfig.Hostname}} ubuntu:14.04

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
    * --name= : 给容器命名, 好处多多的, 代替容器ID
        * sudo docker run --name work -it ubuntu:14.04

## 三 Docker 命令实习:
* `1. 拉取或创建镜像`:
    * 拉取: sudo docker pull ubuntu:14.04
    * 创建: sudo docker build -t "whatwewant/ubuntu:14.04" --no-cache --rm=true - < Dockerfile # 请确保Dockerfile存在
        * 注意: 这里: -t == --tag, 最好指定, 这里不仅仅是标签，更重要的是镜像名字(Repository)，属于自己的，而不是官方的
* `2. 运行镜像IMAGE，即新建容器CONTAINER`:
    * 伪终端交互: sudo docker run --name web -i -t -P ubuntu:14.04
    * Daemon方式: sudo docker run -d -P ubuntu:14.04
* `3. 提交改动`:
    * sudo docker commit -a cole -m "Comments" d10c3120b4d7
* `4. 推送到远程服务器`:
    * sudo docker push whatwewant/ubuntu:14.04
* `5. 删除容器`:
    * sudo docker rm d10c3120b4d7
* `6. 删除镜像`:
    * sudo docker rmi whatwewant/ubuntu:14.04
    * `删除所有镜像: sudo docker rmi -f $(sudo docker ps -aq)`
* `7. 结束容器`:
    * 容器ID: sudo docker kill d10c3120b4d7
    * 容器名字: sudo docker kill web
    * 伪终端结束: exit 或 C-d(Ctrl+d)
* `8. 查看容器或镜像详细信息`: `容器是镜像的实例`
    * sudo docker inspect d10c3 
    * sudo docker inspect ubuntu:14.04
    * 查看个别属性，因为输出是json
    * Ex: sudo docker inspect -f {{.DockerVersion}} ubuntu:14.04
    * Ex: sudo docker inspect -f {{.ContainerConfig.Hostname}} ubuntu:14.04

## 四 Dockerfile 的编写，自定义镜像

* 常用指令: 每个命令在原基础上新建一个容器, 表现为容器ID
    * 1. FROM 
        * 格式: FROM <image>:<tag> 
            * 第一条指令必须为FROM指令。如果在同一个Dockerfile中创建多个镜像时，可以使用多个FROM指令。
        * 例子: FROM ubuntu:14.04
    * 2. MAINTAINER :
        * 格式: MAINTAINER <name> <e-mail>
            * 指定维护信息
        * 例子: MAINTAINER Cole Smith <whatwewant@gmail.com>
    * 3. RUN :
        * 格式: RUN <command> 或 RUN ["executable", "param1", "param2"]
            * 执行系统命令
            * 例子: RUN apt-get install -qqy nginx
            * 例子: RUN ["mkdir", "-p", "/data/v1"]
    * 4. CMD :
        * 格式: CMD ["excutable", "param1", "param2"]
            * 使用exec执行, `一个Dockerfile只能执行一条CMD, 以最后一条为准`
            * Ex(表示例子): CMD ["/usr/sbin/sshd", "-D"]
    * 5. EXPOSE :
        * 格式: EXPOSE <port>
            * 容器暴露端口，一般和docker run -P结合，自动端口映射
            * 可以有多条EXPOSE语句
            * Ex: EXPOSE 80
            * Ex: EXPOSE 80 22
    * 6. ENV :
        * 格式: ENV <keyy> <value>
            *  指定一个环境变量。
        * Ex: ENV PYTHON python3
    * 7. ADD :
        * 格式: ADD <src> <dest>
            * 复制本地或URL<src>到容器<dest>
        * Ex: ADD 
    * 8. COPY :
        * 格式: COPY <src> <dest>
            * 和ADD类似，复制功能，但是src为本地目录是推荐使用
        * Ex: COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
    * 9. VOLUME :
        * 格式: VOLUME []
        * Ex: VOLUME ["/data"]

* `Dockerfile 实习`:

```bash
# Comments
# 拉取镜像
FROM ubuntu:14.04

# 维护者信息
MAINTAINER Cole Smith <tobewhatwewant@gmail.com>

# 更换为163的源，国内你懂的
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty main restricted universemultiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/ubuntu/ trusty-security main restricte universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 更新源
RUN apt-get -qqy update

# 安装软件
# 安装ssh
RUN apt-get install -qqy openssh-server

# 安装nginx
RUN apt-get install -qqy nginx

# 安装supervisor
RUN apt-get install -qqy supervisor

# 复制supervisord配置
# 确保当前目录有 supervisord.conf 文件
# 配置写法，看下边
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 指定主机数据卷(文件夹等)在容器中挂载
# 和 -v HOST_DIR:CONTAINER_DIR 效果一致
# 这里，将主机的/data目录挂载到容器/data, 容器会自动创建/data
VOLUME ["/data"]

# 映射端口
EXPOSE 22 80

# 执行命令
CMD ["/usr/bin/supervisord"]

# 最后，终端创建, 命令如下
# sudo docker build -t whatwewant/ubuntu:14.04 --no-cache --rm - < Dockerfile
```

* supervisor的配置文件supervisord.conf

```bash
[supervisord]
nodaemon=true

[program:sshd]
command=/usr/sbin/sshd -D

[program:nginx]
command=/usr/sbin/nginx start
```

## 五 [我的Dockerfile]({{ site.url }}/confs/Dockerfile)
