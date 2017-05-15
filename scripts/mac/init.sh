#!/bin/bash

PACKAGES="
homebrew
zsh
vim
tmux
python
node
atom
"

Install () {
  for e in "$@";
  do
    echo "Config $e ..."
    ./config_$e
    echo "Config $e Done"
    echo ""
  done
}

Install $PACKAGES
