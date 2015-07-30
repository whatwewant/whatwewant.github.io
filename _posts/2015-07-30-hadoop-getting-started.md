---
layout: post
title: "Hadoop Getting Started"
keywords: [""]
description: ""
category: Linux
tags: [Hadoop, Linux]
---
{% include JB/setup %}

### 一、关于 Hadoop
* 1 Hadoop是什么:
    * Hadoop是Apache的开源的分布式存储以及分布式计算平台
    * [官网](http://hadoop.apache.org)
* 2 Hadoop的两个核心组成:
    * `HDFS`: 分布式文件系统，存储海量的数据
    * `MapReduce`: 并行处理框架,实现任务分解和调度
* 3 Hadoop的用途:
    * 搭建大型数据仓库,PB级数据的存储、处理、分析、统计等业务.
        * `搜索引擎`
        * `日志分析`
        * `商业智能`
        * `数据挖掘`
* 4 Hadoop的优势:
    * `1.高扩展`
    * `2.低成本`
    * `3.成熟的生态圈(Hadoop Ecosysten)`
* 5 Hadoop的生态系统及版本: `HDFS + MapReduce + 开源工具`
    * `1.HIVE`: 只需要编写简单的SQL语句, 转化成Hadoop任务
    * `2.HBASE`: 
        * 存储结构化数据的分布式数据库.
        * 和传统的关系型数据库区别, Hbase放弃失特性，追求更高的扩展
        * `和HDFS区别: Hbase提供数据的随机读写和实时访问, 实现对表数据的读写功能.`
    * `3.Zookeeper`: 监控Hadoop集群的状态，管理Hadoop集群的配置...

### 二、Hadoop的安装(Ubuntu 14.04)

* Step 1: 准备Linux, 这里用Ubuntu 14.04
    
* Step 2: 安装JDK, 这里用OpenJDK 1,7
    * `sudo apt-get update; sudo apt-get install -y openjdk-7-jdk`
    * 设置JAVA环境, 编辑 ~/.bashrc或~/.zshrc 在末尾添加
        * `export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64`
        * `export JRE_HOME=$JAVA_HOME/jre`
        * `export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH`
        * `export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH`
    * 使JAVA环境生效:
        * `source ~/.bashrc` Or `source ~/.zshrc`

* Step 3: 下载Hadoop, 并解压到$HOME目录
    * 1 下载: [官网](https://hadoop.apache.org) 
        * [2.7.1](http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz)
        * [1.2.1](http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz)
        * COMMAND: `wget http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz`
    * 2 解压到WORKDIR目录, WORKDIR自己定，最好在$HOME
        * `tar -zxvf hadoop-1.2.1.tar.gz -C $HOME`

* Step 4 配置Hadoop: Hadoop目录: $HOME/hadoop-1.2.1
    * 四个配置文件, `配置文件目录: $HOME/hadoop-1.2.1/conf`:
        * `core-site.xml`
        * `hadoop-env.sh`
        * `hdfs-site.xml`
        * `mapred-site.xml`

```
// 1 编辑hadoop-env.sh: `vim hadoop-env.sh`
    * 找到JAVA_HOME, 取消注释(去掉`#`)，修改为刚才设置的JAVA_HOME地址
    * `export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64`
```

```
// 2 `vim core-site.xml`
    <configuration>
        <property>
            <!-- 这是注释, Hadoop的工作目录 -->
            <!-- 该目录不要手动创建 -->
            <name>hadoop.tmp.dir</name>
            <value>/home/potter/hadoop</value>
        </property>

        <property>
            <!-- 元数据目录 -->
            <!-- name 目录不要创建 -->
            <name>dfs.name.dir</name>
            <value>/home/potter/hadoop/name</value>
        </property>

        <property>
            <!-- 文件系统的name node -->
            <name>fs.default.name</name>
            <!-- potter 是 hostname, 9000 是hadoop的端口号 -->
            <value>hdfs://potter:9000</value>
        </property>
    </configuration>
```

```
// 3 vim hdfs-site.xml
<configuration>:
    <property>
        <!-- 文件系统数据的存放目录 -->
        <!-- data 目录不要创建, 否则存在权限问题, 如果出现问题，请查看HADOOP_HOME目录下的logs目录文件 -->
        <name>dfs.data.dir</name>
        <value>/home/potter/hadoop/data</value>
    </property>
</configuration>
```

```
// 4 vim mapred-site.xml
<configuration>:
    <property>
        <!-- 任务调度去访问路径 -->
        <name>mapred.job.tracker</name>
        <value>potter:9001</value>
    </property>
</configuration>
```

```
// 5 配置 Hadoop 环境
// vim ~/.bashrc
export HADOOP_HOME=$HOME/hadoop-1.2.1
export PATH=$HADOOP_HOME/bin:$PATH

// 使环境生效
source ~/.bashrc
```

```
// 6 基本环境配置好了，现在继续做必要的操作
// 6.1 Hadoop配置成功与否
% hadoop # 显示帮助则说明hadoop配置没问题

// 6.2 对 namenode 进行格式化, 否则无法启动namenode服务
% hadoop namenode -format
# 成功执行后, /home/potter/hadoop目录及子目录dfs被创建

// 6.3 启动服务
% start-all.sh
# 成功执行后, /home/potter/hadoop/data及/home/potter/hadoop/mapred目录被创建
// 6.3.1 停止服务: stop-all.sh

// 6.4 JPS 查看服务
% jps
如果存在 Jps
        JobTracker
        NameNode
        DataNode
        SecondaryNameNode
        TaskTracker
 六个任务，则说明Hadoop配置没问题

// 6.5 常见问题:
 1. NameNode 和 DataNode 启动不成功解决:
    保证前面配置一致, 则可能在start-all.sh之前没有format namenode.
  这时只要stop-all.sh, 再hadoop namenode -format, 然后在start-all.sh即可

 2. DataNode 启动不成功解决:
    data目录不要手动创建，已创建，请删除,重新stop-all.sh && start-all.sh即可

 3. 其他, 请查看$HADOOP_HOME目录下的logs目录

// 6.6 查看Hadoop的文件命令
% hadoop fs -ls /
% hadoop fs -ls /home
% hadoop fs -ls /home/ubuntu
% hadoop fs -ls /home/ubuntu/hadoop
```

## Hadoop 基本概念: HDFS + MapReduce

### 三、HDFS 系统
* 1 块(Block)
    * HDFS的文件被分成块(Block)进行存储.
    * HDFS块的默认大小为64MB
    * 块是文件存储处理的逻辑单元
    * `HDFS 中有两类节点NameNode + DataNode`

* 2 NameNode
    * 是HDFS的管理节点，存放文件元数据
        * 1 文件与数据块的映射表
        * 2 数据块与数据节点的映射表
    * `客户通过NameNode找到DataNode, 将多个DataNode拼成一个可用的数据`

* 3 DataNode
    * 是HDFS的工作节点，存放数据块

#### 三-2、HDFS中数据管理与容错
* 1 每个数据块有`3个副本`，分布在两个机架内的三个节点.(一个机架可以存放多个DataNode, 数据块存放在DataNode中.其中两份在一个机架，另一个在另一个机架.)以此来保证容错.
* 2 `心跳检测`: DataNode定期向NameNode发送心跳消息.
* 3 `SecondaryNameNode`: 二级NameNode定期同步元数据镜像文件和修改日志NameNode发生故障时，备胎转正.

#### 三-3、文件读写的流程
* HDFS中`文件读取`的流程:
    * `Step 1: 客户端向NameNode发送文件读取请求`
    * `Step 2: NameNode根据客户端发来的文件路径, 查看元数据`
    * `Step 3: NameNode会根据元数据，返回客户端这些数据块及其存放的DataNode`
    * `Step 4: 找到数据块存放的DataNode，读取并组装`

* HDFS中`文件写入`的流程:
    * `Step 1: 客户端文件拆分成块, 每个大小问DataNode的默认大小64MB.`
    * `Step 2: 客户端发送通知给NameNode`
    * `Step 3: NameNode 从机架中查找可用的DataNode返回客户端`
    * `Step 4: 客户端根据NameNode返回的DataNode, 将数据块写入DataNode`
    * `Step 5: 一个数据块写入DataNode后，进行流水线复制两份到不同机架的DataNode`
    * `Step 6: 没一个DataNode复制完成后(一个复制两个)，更新元数据`
    * `Step 7： 写入第二个数据块到DataNode, 重复Step 5...`

#### 三-4、HDFS的特点
* `1.数据冗余，硬件容错`
* `2.流式数据访问`: 一次写入，多次读写; 一旦写入，不会被修改
* `3.存储大文件`: 如果文件很小，对NameNode的压力很大
* 适用性和局限性:
    * `适合数据批量读写，吞吐量高.`
    * `不适合交互式应用，低延迟很难满足`
    * `适合一次写入多次读写，顺序读写`
    * `不支持多用户并发写相同文件`

#### 三-5、HDFS命令行操作

```bash
# hdfs 提供Shell接口, 所以命令和Shell操作很类似
# 直接输入 hadoop fs 可以获得帮助

# 1 查看文件夹
% hadoop fs -ls /

# 2 新建目录
% hadoop fs -mkdir input 
# 该命令会在/usr/potter下创建input目录
# 其中potter为你的hostname
# 用 hadoop fs -ls /usr/potter 查看

# 3 将本地文件提交到hdfs, local_file为本地任意文件
% hadoop fs -put local_file input/ 
# 查看文件
% hadoop fs -ls /user/potter/input
# 查看文件内容
% hadoop fs -cat /usr/potter/input/local_file

# 4 删除文件或目录
% hadoop fs -rm path/to/file

# 5 从HDFS中获取文件到本地
% hadoop fs -get input/remote_file local_new_name
```

### 四、MapReduce框架

#### 四-1. MapReduce 原理
* `分而治之`:
    * `一个大任务分成多个小的子任务(map), 并行执行后，合并结果(reduce)`
    * 栗子: 老师让多个组长一起发作业(map), 老师收作业(reduce)
    * `map: 大变小加上并行执行, reduce: 小变大, 但是map和reduce并不是相反的过程`
* 实际栗子:
    * 1 从100GB的网站访问日志文件中找出访问次数最多的IP地址.

#### 四-2. MapReduce 运行流程
* 基本概念:
    * `Job & Task`: 一个Job被分成多个Task, Task又分为MapTask和ReduceTask
    * `JobTracker`: 客户端提交Job(任务)来, JobTracker将Job分为MapJob和ReduceJob, MapJob 和 ReduceJob又将任务交给Map TaskTracker 和 Reduce TaskTracker
        * 1 作业调度
        * 2 分配任务、监控任务执行进度
        * 3 监控TaskTracker的状态
    * `TaskTracker`: 
        * 1 执行任务
        * 2 向JobTracker汇报任务状态

* 执行流程:
    * `1.输入数据或者数据也来自HDFS`
    * `2.将输入数据分片，执行Map任务(Job), 交给Map端的TaskTracker`
    * `3.中间结果: Key-Value`
    * `4.执行Recude任务(Job), 交给Reduce端的TaskTracker`
    * `5.将输出结果写回到HDFS`

* MapReduce的容错机制
    * 1 重复执行(4次失败后放弃)
    * 2 推测执行

### 五、MapReduce的应用案例

### 案例一、WordCount单词计数
* 问题: 计算文件中出现每个单词的頻数, 输出结果按照字母顺序进行排序.
* 思路:
    * 将文件按行进行切分，每行执行Map操作, 计算每个结果, 然后再Reduce合并
