#!/bin/bash
# File Name: config_mac_icons.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2015年01月05日 星期一 10时45分35秒

script_path=$(cd `dirname $0`; pwd)
UBUNTU_VERSION=$(cat /etc/issue | head -n 1 |awk '{print $2}')

sudo add-apt-repository -y ppa:noobslab/themes
sudo add-apt-repository -y ppa:noobslab/apps
sudo add-apt-repository -y ppa:docky-core/ppa 
sudo apt-get update

case "$UBUNTU_VERSION" in
    "14.04")
        ;;
    "15.04")
        ;;
esac


## 安装mac主题
sudo apt-get install -y unity-tweak-tool
# sudo apt-get install -y gnome-tweak-tool
## docky
sudo apt-get install -y docky
## 添加mac主题源 www.noobslab.com
# sudo add-apt-repository -y ppa:noobslab/themes
# sudo apt-get update
case "$UBUNTU_VERSION" in
    "14.04")
        # Replace 'Ubuntu Desktop' text with 'Mac' on the Panel
        cd /usr/share/locale/en/LC_MESSAGES/
        sudo msgfmt -o unity.mo ${script_path}/../icons/Mac.po
        
        # Apple Logo in Launcher
        sudo cp ${script_path}/../icons/launcher_bfb.png /usr/share/unity/icons/
        # 安装mac主题, unity-tweak-tool 选择 Theme(主题) 选择Mbutun-x
        sudo apt-get install -y mbuntu-y-ithemes-v4
        ## 安装mac主题图标, unity-tweak-tool 选择 Icons(图标) 选择Mbuntu-sl
        sudo apt-get install -y mbuntu-y-icons-v4
        sudo apt-get install -y mbuntu-y-bscreen-v4
        ## Install MacBuntu theme for LightDM
        sudo apt-get install -y mbuntu-y-lightdm-v4
        ## 
        sudo apt-get install -y mbuntu-y-docky-skins-v4
        ;;
    "15.04")
        sudo apt-get install -y mbuntu-y-ithemes-v5
        sudo apt-get install -y mbuntu-y-icons-v5
        sudo apt-get install mbuntu-y-docky-skins-v5
        cd /tmp && wget -O config.sh http://drive.noobslab.com/data/Mac-15.04/config.sh
        chmod +x config.sh;./config.sh
        cd /tmp && wget -O Mac.po http://drive.noobslab.com/data/Mac-15.04/change-name-on-panel/mac.po
        cd /usr/share/locale/en/LC_MESSAGES; sudo msgfmt -o unity.mo ~/Mac.po;rm ~/Mac.po; cd /tmp
        wget -O launcher_bfb.png http://drive.noobslab.com/data/Mac-15.04/launcher-logo/apple/launcher_bfb.png
        sudo mv launcher_bfb.png /usr/share/unity/icons/
        cd /tmp; wget -O mac-fonts.zip http://drive.noobslab.com/data/Mac-15.04/macfonts.zip
        sudo unzip mac-fonts.zip -d /usr/share/fonts; rm mac-fonts.zip
        sudo fc-cache -f -v
        sudo apt-get install -y libreoffice-style-sifr
        sudo apt-get install -y mbuntu-y-lightdm-v5
        ;;
    *)
	[[ -d "/tmp/Mac_Ubuntu" ]] && rm -rf /tmp/Mac_Ubuntu
	git clone https://github.com/whatwewant/Mac_Ubuntu /tmp/Mac_Ubuntu
	cd /tmp/Mac_Ubuntu
	bash install.sh
	;;
esac

case "$UBUNTU_VERSION" in
    "14.04" | "15.04")
	## Slingscold(Alternative to Launchpad)
	sudo apt-get install -y slingscold
	## Indicator Synapse and Mutate (Alternative to Spotlight)
	sudo apt-get install -y indicator-synapse
	## Apply MBuntu Splash
	# Mutate Spolight
	sudo apt-get install -y mutate
        ;;
    *)
        ;;
esac
