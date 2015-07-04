#!/bin/bash
# File Name: config_nodejs.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2014年11月30日 星期日 20时14分08秒

profile=~/.bashrc
if [ "$SHELL" = "/bin/bash" ]; then
    profile=~/.bashrc
elif [ "$SHELL" = "/bin/zsh" ]; then
    profile=~/.zshrc
fi

source $profile >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    profile=~/.bashrc
    source $profile >> /dev/null 2>&1
fi

which node >> /dev/null
if [ "$?" != "0" ]; then
    # sudo apt-get update
    # sudo apt-get install build-essential libssl-dev curl
    # download easy script
    curl https://raw.githubusercontent.com/creationix/nvm/v0.13.1/install.sh | bash
    # profile
    source $profile
    # test nvm (Node Version manager)
    nvm
    # install node
    nvm install v0.10.31
    # list node Version
    # nvm node
fi

echo "Congratulation ! Node Install Successfully!"
