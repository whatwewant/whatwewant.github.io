#!/bin/zsh

source $HOME/.zshrc
REGISTRY=https://registry.npm.taobao.org/
# PREFIX=$HOME/.config/node_modules #

nvm use v5.4.0

if [ "$(npm config get registry)" != "$REGISTRY" ]; then
    npm config set registry $REGISTRY
fi

# if [ "$(npm config get prefix)" != "$PREFIX" ]; then
#  [[ ! -d $PREFIX ]] && mkdir -p $PREFIX
#  npm config set prefix $PREFIX
# fi

if [ "$NODE_PATH" = "" ] && [ ! -d "node_modules" ]; then
    # npm install
    npm install # --registry=https://registry.npm.taobao.org
fi

gulp || (npm install && gulp) # --registry=https://registry.npm.taobao.org && gulp)
