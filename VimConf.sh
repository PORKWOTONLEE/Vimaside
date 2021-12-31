#!/bin/bash
HOME_DIR=~
ROOT_DIR=`pwd`
SRC_DIR=${ROOT_DIR}/src
CACHE_DIR=${SRC_DIR}/cache

# Force install arg
if [ $# == 1 ]
then
    FORCE_INSTALL=$1
else
    FORCE_INSTALL=0
fi

# Create Essential Folder
function CreatEssentialFolder()
{
    [ ! -d "${HOME_DIR}/.vim/" ] && mkdir ${HOME_DIR}/.vim > /dev/null 2>&1
    [ ! -d "${HOME_DIR}/.vim/autoload/" ] && mkdir ${HOME_DIR}/.vim/autoload > /dev/null 2>&1
    [ ! -d "${HOME_DIR}/.vim/colors/" ] && mkdir ${HOME_DIR}/.vim/colors > /dev/null 2>&1
    [ -d "${HOME_DIR}/.vim/colors" -a -d "${HOME_DIR}/.vim/autoload/" -a -d "${HOME_DIR}/.vim/" ] && echo -e "\e[32m :Success \e[0m" && return || echo -e "\e[31m :Fail \e[0m"
}

# Install command through apt
function AptInstall()
{
    for arg in $@; do : ; done
    NeedToInstall ${arg} 
    [ $? == 1 ] && echo -e "\e[34m :Installed \e[0m" && return || sudo apt install -y $1 > /dev/null 2>&1 && echo -e "\e[32m :Success \e[0m" && return || echo -e "\e[31m :Fail \e[0m"
}

# Judge whether to install a command
function NeedToInstall()
{
    type $1 > /dev/null 2>&1 
    [ $? != 0 -o ${FORCE_INSTALL} == 1 ] && return 0
    [ $? == 0 ] && return 1
}

# Local install nodejs
function LocalInstallNodejs()
{
    NeedToInstall node 
    [ $? == 1 ] && echo -e "\e[34m :Installed \e[0m" && return

    mkdir -p ${CACHE_DIR}/nodejs
    tar -xJf ${SRC_DIR}/node-v18.15.0-linux-x64.tar.xz --strip-components 1 -C ${CACHE_DIR}/nodejs
    sudo cp -r ${CACHE_DIR}/nodejs/bin/*     /usr/local/bin/
    sudo cp -r ${CACHE_DIR}/nodejs/lib/*     /usr/local/lib/
    sudo cp -r ${CACHE_DIR}/nodejs/include/* /usr/local/include/

    type node > /dev/null 2>&1 && echo -e "\e[32m :Success \e[0m" && return || echo "\e[31m :Fail \e[0m"
}

# Local installa Gtags 
function LocalInstallGtags()
{
    NeedToInstall gtags
    [ $? == 1 ] && echo -e "\e[34m :Installed \e[0m" && return

    mkdir -p ${CACHE_DIR}/gtags
    tar -xzf ${SRC_DIR}/global-6.6.9.tar.gz --strip-components 1 -C ${CACHE_DIR}/gtags
    cd ${CACHE_DIR}/gtags
    ./configure > /dev/null 2>&1
    sudo make  > /dev/null 2>&1 && sudo make install > /dev/null 2>&1
    cd ${ROOT_DIR}

    type gtags > /dev/null 2>&1 && echo -e "\e[32m :Success \e[0m" && return || echo "\e[31m :Fail \e[0m"
}

# Install command through apt
function AptUpdate()
{
    sudo apt update > /dev/null 2>&1 && echo -e "\e[32m :Success \e[0m" || echo -e "\e[31m :Fail \e[0m"
}

# Vim Plugin Config
function VimPlugConfig()
{
    # Install vim-plug
    cp ${SRC_DIR}/plug.vim ${HOME_DIR}/.vim/autoload/ > /dev/null 2>&1
    vim -c ":PlugInstall" ${SRC_DIR}/tips.md
    # Install vim theme
    cp ${SRC_DIR}/molokai.vim ${HOME_DIR}/.vim/colors/ > /dev/null 2>&1

    # Installed cocnvim
    cd ${HOME_DIR}/.vim/plugged/coc.nvim
    git checkout release > /dev/null 2>&1
    cd ${ROOT_DIR}
    vim -c ":CocInstall coc-clangd" ${SRC_DIR}/tips.md
    echo -e "\e[32m :Success \e[0m"
}

# Vimrc Config
function VimrcConfig()
{
    cp ${SRC_DIR}/vimrc ~/.vimrc > /dev/null 2>&1
    [ -f ${HOME_DIR}/.vimrc ] && echo -e "\e[32m :Success \e[0m" || echo -e "\e[31m :Fail \e[0m"
}

# Cleaning
function Clean()
{
    sudo rm -rf ${ROOT_DIR}/yarn.lock 
    sudo rm -rf ${ROOT_DIR}/node_modules
    sudo rm -rf ${CACHE_DIR}
    sudo rm -rf ${ROOT_DIR}/tmp 
    echo -e "\e[32m :Success \e[0m"
}

# Tip
echo -e "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo -e "x Add arg 1 behind the script to enable FORCE_INSTALL/UPDATE!!! x"
echo -e "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# Test root
[ -d tmp ] && sudo rm -rf tmp || sudo mkdir tmp 
[ ! -d tmp ] && echo -e "Use root to Continue!!!\c" && exit 1 || echo -e "Root Confirm!!!" 
# Main 
echo -e "(1/5)[PreProgress]"
echo -e "  (1/3)[creat essential folder]\c"
CreatEssentialFolder
echo -e "  (2/3)[apt update]\c"
AptUpdate
echo -e "  (3/3)[common dependencies]"
echo -e "    (1/6)[git]\c"
AptInstall git
echo -e "    (2/6)[ncurses]\c"
AptInstall libncurses-dev ncurses5-config
echo -e "    (3/6)[xz]\c"
AptInstall xz-utils xz
echo -e "    (4/6)[bear]\c"
AptInstall bear
echo -e "    (5/6)[gcc]\c"
AptInstall gcc
echo -e "    (6/6)[make]\c"
AptInstall make 
echo -e "(2/5)[Vim Plug Dependencies]"
echo -e "  (1/2)[coc.nvim]"
echo -e "    (1/3)[clangd]\c"
AptInstall clangd 
echo -e "    (2/3)[ripgrep]\c"
AptInstall ripgrep rg 
echo -e "    (3/3)[nodejs]\c"
LocalInstallNodejs
echo -e "  (2/2)[tagbar]"
echo -e "    (1/1)[gtags]\c"
LocalInstallGtags
echo -e "(3/5)[Vimrc]\c"
VimrcConfig
echo -e "(4/5)[Vim Plug Install]\c"
VimPlugConfig
echo -e "(5/5)[Clean]\c"
Clean

