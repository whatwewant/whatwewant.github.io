#!/bin/zsh

source $HOME/.zshrc
REGISTRY=https://registry.npm.taobao.org/

nvm use v5.4.0

if [ "$(npm config get registry)" != "$REGISTRY" ]; then
    npm config set registry="$REGISTRY"
fi

if [ "$NODE_PATH" = "" ] && [ ! -d "node_modules" ]; then
    # npm install
    sudo npm install # --registry=https://registry.npm.taobao.org
fi

gulp || (sudo npm install && gulp) # --registry=https://registry.npm.taobao.org && gulp)
