
which atom >> /dev/null
if ! [ $? -eq 0 ]; then 
  # echo "Please install atom first.";
  # exit -1
  echo "Install atom ..."
  brew cask install atom
fi

function Install() {
  for e in "$@";
  do
    echo "Install $e ..."
    apm install $e
  done
}

echo "正在安装 通用 插件 ..."

Install emmet \
        file-icons \
        file-header \
        highlight-column \
        minimap \
        vim-mode \
        terminal-plus \
        atom-beautify \
        pigments \
        markdown-scroll-sync \
        autocomplete-sass \
        autocomplete-modules \
        docblockr \
        remote-sync

echo "正在安装 React 插件 ..."
        # atom-react-autocomplete \
Install react

echo "正在安装 Vue 插件 ..."
Install vue-autocomplete
