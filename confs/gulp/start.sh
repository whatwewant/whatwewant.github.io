#!/bin/zsh

source $HOME/.zshrc

nvm use v5.4.0

if [ "$NODE_PATH" = "" ] && [ ! -d "node_modules" ]; then
    # npm install
    sudo npm install --registry=https://registry.npm.taobao.org
fi

gulp || (sudo npm install && gulp)
