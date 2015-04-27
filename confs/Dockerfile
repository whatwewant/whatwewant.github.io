# How to:
#   sudo docker build -t "whatwewant/ubuntu14.04" --no-cache --rm=true - < Dockerfile
FROM ubuntu:14.04
MAINTAINER Cole Smith <tobewhatwewant@gmail.com>

# backup old sources.list
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bac

# add new sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list

# update new sources.list
RUN apt-get -y update

# install nginx
RUN apt-get install -qqy nginx

# install mysql
# RUN apt-get install -qqy mysql-server

# install ruby
# RUN apt-get -qqy install ruby ruby-dev

# RUN gem install docker
# RUN apt-get install -y vim
