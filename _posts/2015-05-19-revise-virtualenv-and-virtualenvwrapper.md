---
layout: post
title: "重新捡起 virtualenv and virtualenvwrapper"
keywords: [python, virtualenv, virtualenvwrapper]
description: Virtual Environment Supported By Python
category: python
tags: [python, virtualenv, virtualenvwrapper]
---
{% include JB/setup %}

## 官方文档
* [virtualenv](https://virtualenv.pypa.io/en/latest/)
* [virtualenvwrapper](https://virtualenvwrapper.readthedocs.org/en/latest/)

# 一 virtualenv
* `What`:
    * virtualenv 是一个隔离Python环境的工具.
* `Why`:
    * virtualenv 可以让你在同一个操作系统上建立多个不同的Python环境.
    *  如一个Python2, 另一个Python3,　还有Django1.2 和 Django1.5
    * 项目Python环境互不相同，互不干涉.
* `How`: (So Easy)
    * `Install`: 
        * sudo pip install virtualenv
    * `Use`: (Recommend)
        * `创建环境`:
            * `virtualenv -p PYTHON_VERSION VIRTUAL_ENVIRONMENT_NAME`
            * 解释:
                * -p PYTHON_EXE, --python=PYTHON_EXE : 指定Python版本, Python2, Python2.5, Python3等
                * 注意: 这个Python版本必须存在于系统内部
                * --no-site-packages : 废弃了，因为默认没有权限访问全局包
             * 栗子:
                * `virtualenv -p python3 django1.8`
        * `进入环境`:
            * source path/to/VIRTUAL_ENVIRONMENT_NAME/bin/activate
            * 栗子:
                * source django1.8/bin/activate
                * 或者 cd django1.8; source bin/activate
            * `有明显标志(VIRTUAL_ENVIRONMENT_NAME)，说明成功进入环境`
        * `退出环境`:
            * deactivate
        * `删除环境`:
            * 只要删除创建的虚拟环境目录即可: rm -rf path/to/VIRTUAL_ENVIRONMENT_NAME
                * rm -rf django1.8

# 二 virtualenvwrapper
* `what`:
    * virtualenvwrapper 是 virtaulenv 的扩展的集合.
* `Why`:
    * 便于使用和管理 virtualenv
* `How`:
    * `Install`:
        * sudo pip install virtualenvwrapper
    * `Use`:
        * `每次使用前必须先source环境`: 才有mkvirtualev, lssitepackages等命令
            * `source /usr/local/bin/virtualenvwrapper.sh`
            * `或者将/etc/profile 或者 ~/.bashrc 或者 ~/.zshrc` 启动终端时自动载入source
        * `创建环境`:
            * Syntax: `mkvirtualenv [-a project_path] [-i package] [-r requirements_file] [virtualenv options] VIRTUAL_ENVIRONMENT_NAME`
            * `注意: 项目默认创建一律在 ~/.virtualenvs 目录下`
            * 栗子:
            * 默认: 
                * mkvirtualenv django1.8 # (ls ~/.virtualenvs 可见)
            * 指定Python版本: 
                * mkvirtualenv -p python3 django1.8
            * 指定Python版本和依赖的包: 
                * mkvirtualenv -r requirements.txt -p python3 django1.8
            * 指定项目地址, 只要载入环境，自动切换到项目目录:
                * mkvirtualenv -a . django1.8
            * `注意: 环境创建完成后，会自动载入环境`
        * `打开或切换工作环境`:
            * Syntax: `workon [(-c|--cd)|(-n|--no-cd)] [environment_name|"."]`
            * 栗子:
            * 默认:
                * workon django1.8
                * `注意: 默认进入 mkvirtualenv 选项 -a 指定的目录，如果没有，则在当前目录`
            * 切换, 即已经在一个虚拟环境, 但要切换另一个环境:
                * workon django1.5
            * 不进入 -a 指定的目录:
                * workon -n django1.8
        * `退出环境，使用系统环境`:
            * deactivate
        * `删除环境`:
            * rmvirtualenv VIRTUAL_ENVIRONMENT_NAME 
            * 或 rm -rf ~/.virtualenvs/VIRTUAL_ENVIRONMENT_NAME
            * 栗子:
                * rmvirtualenv django1.8 (推荐)
                * rm -rf ~/.virtualenvs/django1.8

        * `让所有创建的环境都执行某个命令,比如安装某个包等`:
            * Syntax: `allvirtualenv command with arguments`
            * 栗子:
                * allvirtualenv pip install ipython
        * `切换当前环境能否访问系统的Python包, 建议关闭(disable)`:
            * Syntax: `toggleglobalsitepackages [-p]`
                * -p : 不输出日志
            * 栗子:
                * toggleglobalsitepackages
        * `删除第三方包`: (注意: 必须已经在虚拟环境中)
            * Syntax: `wipeenv`
        * `创建项目+环境`:
            * Create a new virtualenv in the WORKON_HOME and project directory in PROJECT_HOME.
            * Syntax: `mkproject [-f|--force] [-t template] [virtualenv_options] ENVNAME`
            * `注意设置 WORKON_HOME 和 PROJECT_HOME`
        * 其他命令:
            * 显示安装的包: lssitepackages (建议用 pip list 更清楚)
            * 复制一份虚拟环境: cpvirtualenv [sorce] [dest]
                * cp django1.8 django
            * 临时环境，deactivate后删除:
                * mktmpenv [(-c|--cd)|(-n|--no-cd)] [VIRTUALENV_OPTIONS]
                * 栗子: mktmpenv -p python3
            * 列出所有创建的虚拟环境: 即~/.virtualenvs目录下的
                * lsvirtualenv [-b|-l|-h]
                    * -b 简短形式, 建议
                    * -l 默认的详细信息输出
                    * -h help
            * `绑定项目目录`:
                * Syntax: `setvirtualenvproject [virtualenv_path project_path]`
