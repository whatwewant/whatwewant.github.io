# 拉取镜像
FROM ubuntu:14.04

# 维护者信息
MAINTAINER Cole Smith <tobewhatwewant@gmail.com>

# backup old sources.list
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bac

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

# nginx
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
