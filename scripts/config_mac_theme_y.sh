#!/bin/bash
# File Name: config_mac_icons.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2015年01月05日 星期一 10时45分35秒

script_path=$(cd `dirname $0`; pwd)

sudo add-apt-repository -y ppa:noobslab/themes
sudo add-apt-repository -y ppa:noobslab/apps
sudo add-apt-repository -y ppa:docky-core/ppa 

# Replace 'Ubuntu Desktop' text with 'Mac' on the Panel
cd /usr/share/locale/en/LC_MESSAGES/
sudo msgfmt -o unity.mo ${script_path}/../icons/Mac.po

# Apple Logo in Launcher
sudo cp ${script_path}/../icons/launcher_bfb.png /usr/share/unity/icons/

## 安装mac主题
sudo apt-get install -y unity-tweak-tool
## docky
sudo apt-get install -y docky
## 添加mac主题源 www.noobslab.com
# sudo add-apt-repository -y ppa:noobslab/themes
# sudo apt-get update
# 安装mac主题, unity-tweak-tool 选择 Theme(主题) 选择Mbutun-x
sudo apt-get install -y mbuntu-y-ithemes-v4
## 安装mac主题图标, unity-tweak-tool 选择 Icons(图标) 选择Mbuntu-sl
sudo apt-get install -y mbuntu-y-icons-v4
## Slingscold(Alternative to Launchpad)
sudo apt-get install -y slingscold
## Indicator Synapse and Mutate (Alternative to Spotlight)
sudo apt-get install -y indicator-synapse
## Apply MBuntu Splash
sudo apt-get install -y mbuntu-y-bscreen-v4
## Install MacBuntu theme for LightDM
sudo apt-get install -y mbuntu-y-lightdm-v4
## 
sudo apt-get install -y mbuntu-y-docky-skins-v4

