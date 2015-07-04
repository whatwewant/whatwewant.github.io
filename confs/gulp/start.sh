#!/bin/bash

if [ ! -d "node_modules" ]; then
    npm install --registry=https://registry.npm.taobao.org
fi

gulp
