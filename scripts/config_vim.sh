#!/bin/bash
echo "安装将花费一定时间，请耐心等待直到安装完成^_^"
if which apt-get >/dev/null; then
	sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools python-dev git
elif which yum >/dev/null; then
	sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel	
fi

sudo easy_install -ZU autopep8 twisted

if [ ! -f "/usr/local/bin/ctags" ]; then
    sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
fi

if [ -f "~/.vimrc" ] || [ -d "~/.vim" ]; then
	mv -f ~/.vimrc ~/.vim >> /dev/null 2>&1
	mv -f ~/.vim ~/.vim_old >> /dev/null 2>&1
fi

# git clone https://github.com/whatwewant/vim.git ~/.vim
# mv -f ~/.vim/.vimrc ~/
wget http://whatwewant.github.io/confs/vimrc -O ~.vimrc

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "正在努力为您安装bundle程序" > potter
echo "安装完毕将自动退出" >> potter
echo "请耐心等待" >> potter
vim potter -c "BundleInstall" -c "q" -c "q"
rm potter
echo "安装完成"
