#!/bin/bash
# File Name: config_init_background_image.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2015年05月04日 星期一

CURRENT_PATH=$(cd `dirname $0`; pwd)

COPY () {
    LOCAL_FILE=$CURRENT_PATH/$1
    NEW_NAME=/usr/local/bin/$2
    [[ ! -d "/usr/local/bin" ]] && sudo mkdir -p /usr/local/bin
    sudo cp $LOCAL_FILE $NEW_NAME
}

# 1. control cpu frequence
COPY control_cpu_frequent.sh control_cpu_frequence

# 2. shadowsocks_global
COPY linux-shdowsocks-global.sh shadowsocks_global

# 3. QDU_EDU_CN
COPY QDU_EDU_CN.sh QDU_EDU_CN

# 4. config_desktop_shortcuts
COPY config_desktop_shortcuts.sh config_desktop_shortcuts

# 5. wifi ap
COPY ./Commands/wifi.sh wifi

# 6. update_kernel
COPY ./update_kernel.py update_kernel

# 7. zshrc 
copy $CURRENT_PATH/../confs/zshrc $HOME/.zshrc
