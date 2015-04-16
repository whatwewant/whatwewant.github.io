#!/bin/bash
echo "安装将花费一定时间，请耐心等待直到安装完成^_^"

# Backup Old Config
# if [ -f "~/.vimrc" ] || [ -d "~/.vim" ]; then
# sudo mv ~/.vimrc ~/.vim >> /dev/null 2>&1
# sudo mv ~/.vim ~/.vim_backup-$(date +%Y-%m-%d) >> /dev/null 2>&1
# fi
mkdir ~/.backup >> /dev/null 2>&1
cp ~/.vimrc ~/.vim >> /dev/null 2>&1
tar -zcvf ~/.backup/vim-$(date +%Y-%m-%d).tgz ~/.vim >> /dev/null 2>&1
sudo rm -rf ~/.vim*

# git clone https://github.com/whatwewant/vim.git ~/.vim
# mv -f ~/.vim/.vimrc ~/
wget http://whatwewant.github.io/confs/vimrc -O ~/.vimrc

# bundle
mkdir -p ~/.vim/bundle && \
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if which apt-get >/dev/null; then
	sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools python-dev git
elif which yum >/dev/null; then
	sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel	
fi

sudo easy_install -ZU autopep8 twisted

if [ ! -f "/usr/local/bin/ctags" ]; then
    sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
fi

echo "正在努力为您安装bundle程序" > potter
echo "安装完毕将自动退出" >> potter
echo "请耐心等待" >> potter
# vim potter -c "PulginInstall" -c "q" -c "q"
vim potter +PluginInstall +qall
rm potter
echo "安装完成"
