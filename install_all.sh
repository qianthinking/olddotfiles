#!/bin/bash

function install_script {
    REQUIRE_INPUT=true
    while $REQUIRE_INPUT; do
        read -p "Do you wish to install this $1(old files will be renamed with time suffix)?" yn
        case $yn in
            [Yy]* ) 
                mv ~/$1{,.`date +%F_%T`} 2>/dev/null
                ln -fns $INSTALL_DIR/dotfiles/$1 ~/$1
                REQUIRE_INPUT=false
                ;;
            [Nn]* ) ;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

INSTALL_DIR=${INSTALL_DIR:-~/.config_all}
mkdir -p $INSTALL_DIR

#install git-prompt
if [ -d "$INSTALL_DIR/git-prompt" ]; then
    cd $INSTALL_DIR/git-prompt
    git pull
else
    cd $INSTALL_DIR
    git clone git://github.com/qianthinking/git-prompt.git
    echo "[[ \$- == *i* ]] && . $INSTALL_DIR/git-prompt/git-prompt.sh" >> ~/.bash_profile
    ln -fns $INSTALL_DIR/git-prompt/git-prompt.conf ~/.git-prompt.conf
fi

#install tmux
if [ -d "$INSTALL_DIR/dotfiles" ]; then
    cd $INSTALL_DIR/dotfiles
    git pull
else
    cd $INSTALL_DIR
    git clone git://github.com/qianthinking/dotfiles.git
    echo ". $INSTALL_DIR/dotfiles/.bashrc.addon" >> ~/.bashrc
    install_script ".gitconfig"
    install_script ".pentadactylrc"
    install_script ".tmux.conf"
fi

if [ -d "$INSTALL_DIR/dotvim" ]; then
    cd $INSTALL_DIR/dotvim
    git pull
    make update_submodules
else
    cd $INSTALL_DIR
    REQUIRE_INPUT=true
    while $REQUIRE_INPUT; do
        read -p "Do you wish to install this vim config into ~/.vim and ~/.vimrc(old files will be renamed with time suffix)?" yn
        case $yn in
            [Yy]* ) 
                mv ~/.vim{,.`date +%F_%T`} 2>/dev/null
                mv ~/.vimrc{,.`date +%F_%T`} 2>/dev/null
                mv ~/.gvimrc{,.`date +%F_%T`} 2>/dev/null
                git clone git://github.com/qianthinking/dotvim.git
                ln -fns $INSTALL_DIR/dotvim ~/.vim
                cd $INSTALL_DIR/dotvim
                make clean
                make
                REQUIRE_INPUT=false
                ;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi
