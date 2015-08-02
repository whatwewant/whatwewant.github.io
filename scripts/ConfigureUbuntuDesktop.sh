#!/bin/bash
# Program:
#	Configure Ubuntu
#
#	Conditions:
#	   Ubuntu, Kubuntu, Lubuntu, Xubuntu, and other OSes based on ubuntu
#
# History:
#     2015/05/04 Cole Smith  Version 1.0.0

# set -e

BASEPATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=.:$BASEPATH

CONFIG_FILE=$(pwd)
CONFIG_DIR=$HOME/.config/Cud
LOG_FILE=$CONFIG_DIR/ConfigureUbuntu-$(date +%Y-%m-%d_%H-%M-%S).log
LOG_DIR=/tmp/ConfigureUbuntu
BLOG_DIR=$CONFIG_DIR/whatwewant
SCRIPT_DIR=$BLOG_DIR/scripts

initialize () {
    # 1. LOG_DIR
    [[ -d "$LOG_DIR" ]] && rm -rf $LOG_DIR || mkdir $LOG_DIR

    # 2. CONFIG_DIR
    [[ ! -d "$CONFIG_DIR" ]] && mkdir -p $CONFIG_DIR

    # 3. LOG FILE
    touch $LOG_FILE

    # 4. backup sources.list
    [[ ! -f /etc/apt/sources.list.old ]] && \
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.old

    # 5. update software sources
    sudo apt-get update
}

initialize

download_log() {
    # 使用前修复依赖
    sudo apt-get -f -y install

    for argv in "$@"
    do
	sudo apt-get install -y $argv && \
        echo "Succeed in installing --> $argv" >> $LOG_FILE || \
        echo "ERROR: Failed to install $argv" >> $LOG_FILE
    done
}

dpkg_log() {
    # 使用前修复依赖
    sudo apt-get -f -y install

    for argv in "$@"
    do
        sudo dpkg -i $argv && \
            echo "(DPKG)Succeed in installing --> $argv" >> $LOG_FILE || \
            echo "(DPKG)ERROR: Failed to install $argv" >> $LOG_FILE
    done
}

pip_log() {
    for argv in "$@"
    do
        sudo pip install $argv && \
            echo "(PIP)Succeed in installing --> $argv" >> $LOG_FILE || \
            echo "(PIP)ERROR: Failed to install $argv" >> $LOG_FILE
    done
}

pip3_log() {
    for argv in "$@"
    do
        sudo pip3 install $argv && \
            echo "(PIP3)Succeed in installing --> $argv" >> $LOG_FILE || \
            echo "(PIP3)ERROR: Failed to install $argv" >> $LOG_FILE
    done
}

easy_install_log() {
    for argv in "$@"
    do
        sudo easy_install $argv && \
            echo "(EASY_INSTALL)Succeed in installing --> $argv" >> $LOG_FILE || \
            echo "(EASY_INSTALL)ERROR: Failed to install $argv" >> $LOG_FILE
    done
}

wget_copy() {
    # wget_copy url rename path
    # Eg: wget https://xxxx kuwo /usr/bin
    url=$1
    newname=$2
    path=$3
    wget -T 20 --tries 2 $url -O $newname && \
    chmod 755 $newname && \
    sudo cp -v $newname $path && \
        echo "Succeeding in wget_copy --> $newname" >> $LOG_FILE || \
        echo "ERROR: failed to wget_copy --> $url" >> $LOG_FILE
}

make_log() {
    make_dir=$1
    cd $make_dir
    make clean
    make && sudo make install \
        && echo "(make)Succeed in installing --> $make_dir" >> $LOG_FILE || echo \
        "ERROR: Failed to install $make_dir" >> $LOG_FILE
}

cmake_log() {
    cmake_dir=$1
    cd $cmake_dir
    mkdir build
    cd build
    cmake ..
    make && sudo make install && \
        echo "(cmake)Succeed in installing --> $cmake_dir" >> $LOG_FILE || \
        echo "ERROR: Failed to install $cmake_dir" >> $LOG_FILE
}

pip2_setup_log() {
    git_dir=$1
    cd $git_dir
    sudo python2 setup.py install && \
        echo "(pip2_setup)Succeed in installing --> $git_dir" >> $LOG_FILE || \
        echo "ERROR: Failed to install $git_dir" >> $LOG_FILE
}

pip3_setup_log() {
    git_dir=$1
    cd $git_dir
    sudo python3 setup.py install && \
        echo "(pip3_setup)Succeed in installing --> $git_dir" >> $LOG_FILE || \
        echo "ERROR: Failed to install $git_dir" >> $LOG_FILE
}

git_log() {
    url=$1
    name=$2
    cd $LOG_DIR
    git clone $url $name && \
        echo "(GIT)Succeed in cloning --> $name" >> $LOG_FILE || \
        echo "ERROR: Failed to clone $name" >> $LOG_FILE
}

bash_log() {
    dir=$1
    script=$2
    cd $dir
    bash $script && \
        echo "(pip3)Succeed in installing --> $dir/$script" >> $LOG_FILE || \
        echo "ERROR: Failed to install $dir/$script" >> $LOG_FILE
}

git_pip() {
    url=$1
    name=$2
    git_log $url $name
    pip3_setup_log $LOG_DIR/$name
}

git_make() {
    url=$1
    name=$2
    git_log $url $name
    make_log $LOG_DIR/$name
}

git_cmake() {
    url=$1
    name=$2
    git_log $url $name
    cmake_log $LOG_DIR/$name
}

git_bash() {
    url=$1
    name=$2
    script=$3
    git_log $url $name
    bash_log $LOG_DIR/$name $script
}

# Bradcom 802.11 Linux STA 无线网卡驱动
# apt-get install -y bcmwl-kernel-source && \
# apt-get install -y broadcom-sta-common && \
# apt-get install -y broadcom-sta-common && \
# apt-get install -y broadcom-sta-source && \
# Broad 43xx 固件提取工具
# apt-get install -y b43-fwcutter && \
# apt-get install -y firmware-b43-installer && \
# 激活无线网卡
# modprobe -r b43 ssb && \
# modprobe b43  || echo "error: 无线网卡安装失败." >> $LOG_FILE

# 调教Nvidia驱动
# http://wiki.ubuntu.org.cn/NVIDIA
# https://github.com/Bumblebee-Project/Bumblebee
# https://launchpad.net/~bumblebee/+archive/stable
#add-apt-repository ppa:bumblebee/stable && \
#apt-get update && \
#apt-get install -y bumblebee bumblebee-nvidia  
#add-apt-repository ppa:ubuntu-x-swat/x-updates && \
#apt-get update && \
#apt-get install -y nvidia-current nvidia-settings && \
# 从事GPU开发的可能还需要装上cuda和openCL库的支持
#apt-get install -y nvidia-current-dev || echo "error: 安装Nvidia drivers failed." >> $LOG_FILE
# "Need reboot
# "The Follow to See how Nvidia Run
# sudo optirun nvidia-settings -c :8
# "To run program using Nvidia
# sudo optirun + program_name
#
#
# add following to /etc/apt/sourcelist
# 12.04 and Me (kernel 3.8)
#	deb http://ppa.launchpad.net/bumblebee/stable/ubuntu precise main 
#	deb-src http://ppa.launchpad.net/bumblebee/stable/ubuntu precise main 
# 
# 13.10:
#	deb http://ppa.launchpad.net/bumblebee/stable/ubuntu saucy main 
#	deb-src http://ppa.launchpad.net/bumblebee/stable/ubuntu saucy main 
#
# 14.04:
#       deb http://ppa.launchpad.net/bumblebee/stable/ubuntu trusty main 
#	deb-src http://ppa.launchpad.net/bumblebee/stable/ubuntu trusty main 
#
# 14.04
download_log bumblebee

# 安装需要的程序
# Program:
# vim and tools
download_log vim 
# download_log tig

# git
download_log git git-flow 
# download_log gitk subversion  

# build-essential
download_log build-essential
# c/c++
download_log gcc g++
# cmake
download_log cmake

# IDE
download_log geany
# download_log codeblocks

# 截图工具
download_log shutter

# 画图/网站结构画图
download_log pinta

# python
download_log python python-setuptools python-virtualenv python-pip ipython
download_log python-mysqldb
# python3
download_log python3-setuptools python3-pip
# pip packages
pip_log BeautifulSoup4
pip_log requests 
pip_log django
pip_log qduTAportal qdudomportal simplefileserver
pip_log speedtest-cli

# Database
download_log sqlite3
# mysql-server
#download_log mysql-server
# mysql-client
download_log mysql-client python-mysqldb

# Life flash smplayer
download_log smplayer 

# flash
download_log firefox
download_log flashplugin-installer

# FTP Client
# download_log filezilla
# FTP Server
# download_log vsftpd

# ssh Client
download_log openssh-client
# ssh Server
# download_log openssh-server openssh-sftp-server

# virtualbox
download_log virtualbox
# VBoxGuestAdditions
# 	http://download.virtualbox.org/virtualbox

# openjdk
download_log openjdk-7-jdk

# stardict
download_log stardict

# 编码(code)
download_log convmv

# go through dirs
download_log tree

# uncompress tool
download_log unrar

# input method
download_log fcitx fcitx-googlepinyin
# fonts
download_log ttf-wqy-zenhei

# For android studio 
download_log lib32z1

# System Tools
download_log fping hping3 htop nmap

# Install Goagent
# https://wiki.archlinux.org/index.php/GoAgent_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)
# git clone https://github.com/goagent/goagent /usr/share/goagent
# wget_copy http://git.oschina.net/sunnypotter/goagent/raw/master/server/uploader.sh uploader.sh /usr/share/goagent/server

# Straight Download binary file: njit-clinet
#
#wget -O /usr/bin/njit-client https://gitcafe.com/Potter/Softwares/raw/master/Njit-client/njit-client && \
#chmod +x /usr/bin/njit-client && echo "Succeed in installing --> njit-client" >> $LOG_FILE

# shadowsocks
# download_log python-m2crypto
# easy_install_log shadowsocks

# 安装 chrome
# wget https://gitcafe.com/Potter/Softwares/raw/master/google-chrome-stable_current_amd64.deb && \
#dpkg -i google-chrome-stable_current_amd64.deb && \
# echo "Succeeding in installing --> google-chrome"|| echo "error: failed to install google-chrome" >> $LOG_FILE

# My Script 
[[ -d "$BLOG_DIR" ]] && rm -rf $BLOG_DIR || \
    git clone http://github.com/whatwewant/whatwewant.io $BLOG_DIR
# export path
export PATH=$SCRIPT_DIR:$PATH

# 安装mac主题
config_mac_theme_y.sh
# config vim zsh tmux
config_vim.sh
config_zsh.sh
config_tmux.sh
# config create ap
config_create_ap.sh
# background
config_init_background_images.sh
# config nodejs
config_nodejs.sh
# config pcs
config_pcs.sh
# install shadowsocks 
install_shadowsocks_libev.sh
# install docker
install_docker.sh
# install monaco font
install-monaco-font-ubuntu.sh
# copy_scripts_to_usr_local_bin
copy_scripts_to_usr_local_bin.sh
# install sogou input method
install_sogou.sh
# install wps
install_wps.sh
# create_ap
config_create_ap.sh
# phpstorm
install_phpstorm.sh
# docker
install_docker.sh

# 安装Brackets.io , html, js
# http://brackets.io
# wget_copy https://github.com/adobe/brackets/releases/download/release-0.44/Brackets.Release.0.44.64-bit.deb Brackets.deb /tmp
# dpkg_log /tmp/Brackets.deb

# Log Report:
cat $LOG_FILE
# rm -rf $LOG_DIR
# rm -rf $CONFIG_FILE
echo "More detail, please look at $LOG_FILE"
# rm -rf $LOG_FILE*

echo "Reboot 10 seconds later..."
sleep 10

# reboot 
read -p "Are you sure to reboot ?(Y/N)" answer
if [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
	sudo reboot
fi

exit 
