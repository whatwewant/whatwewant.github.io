#*************************************************************************
#	> File Name: AutoConfigUbuntuJDKScript.sh
#	> Author: 
#	> Mail: 
#	> Created Time: 2014年08月28日 星期四 10时35分05秒
# ************************************************************************/
#!/bin/bash

# root
if [ `id -u` != "0" ]; then
    echo "You need use root"
    exit 1
fi

# Main Dir
mainDir="/opt/Java/jdk/"
sudo mkdir -p  $mainDir
cd $mainDir
mkdir jdk1.7

# 1、download JDK
#wget http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz
rm -rf jdk1.7.tar.gz
rm -rf jre1.7.tar.gz
wget https://gitcafe.com/Potter/Softwares/raw/master/jdk1.7/jdk-7u67-linux-x64.tar.gz -O jdk1.7.tar.gz
wget https://gitcafe.com/Potter/Softwares/raw/master/jdk1.7/jre-7u67-linux-x64.tar.gz -O jre1.7.tar.gz

# 2、uncompressed
tar -zxvf jdk1.7.tar.gz
tar -zxvf jre1.7.tar.gz
rm -rf jdk1.7.tar.gz
rm -rf jre1.7.tar.gz

mv jdk1.7.0_67/* jdk1.7
mv jre jdk1.7
rm -rf jdk1.7.0_67

# 3、config .bashrc
echo "export JAVA_HOME=/opt/Java/jdk/jdk1.7" >> /etc/profile
echo "export CLASSPATH=${JAVA_HOME}/lib:." >> /etc/profile
echo "export PATH=${JAVA_HOME}/bin:$PATH" >> /etc/profile

# make it Work imediatelly
# source /etc/profile

exit 0
