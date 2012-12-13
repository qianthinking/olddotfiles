#!/bin/bash

function install_script {
    mv ~/$1{,.`date +%F_%T`} 2>/dev/null
    ln -fns $INSTALL_DIR/dotfiles/$1 ~/$1
}

INSTALL_DIR=~/.config_all
echo "install to $INSTALL_DIR"
mkdir -p $INSTALL_DIR
if [ ! -d "$INSTALL_DIR" ]; then
    exit
fi

#install git-prompt
if [ -d "$INSTALL_DIR/git-prompt" ]; then
    cd $INSTALL_DIR/git-prompt
    git pull
else
    cd $INSTALL_DIR
    git clone git://github.com/qianthinking/git-prompt.git
    if ! grep "git-prompt.sh" ~/.bash_profile; then
        echo "[[ \$- == *i* ]] && . $INSTALL_DIR/git-prompt/git-prompt.sh" >> ~/.bash_profile
    fi
    if ! grep "git-prompt.sh" ~/.bashrc; then
        echo "[[ \$- == *i* ]] && . $INSTALL_DIR/git-prompt/git-prompt.sh" >> ~/.bashrc
    fi
    ln -fns $INSTALL_DIR/git-prompt/git-prompt.conf ~/.git-prompt.conf
fi

#install tmux
if [ -d "$INSTALL_DIR/dotfiles" ]; then
    cd $INSTALL_DIR/dotfiles
    git pull
else
    cd $INSTALL_DIR
    git clone git://github.com/qianthinking/dotfiles.git
    if ! grep "bashrc.addon" ~/.bashrc; then
        echo ". $INSTALL_DIR/dotfiles/.bashrc.addon" >> ~/.bashrc
    fi
    install_script ".gitconfig"
    install_script ".tmux.conf"
fi

if [ -d "$INSTALL_DIR/dotvim" ]; then
    cd $INSTALL_DIR/dotvim
    git pull
    make update_submodules
else
    cd $INSTALL_DIR
    REQUIRE_INPUT=true
    mv ~/.vim{,.`date +%F_%T`} 2>/dev/null
    mv ~/.vimrc{,.`date +%F_%T`} 2>/dev/null
    mv ~/.gvimrc{,.`date +%F_%T`} 2>/dev/null
    git clone git://github.com/qianthinking/dotvim.git
    ln -fns $INSTALL_DIR/dotvim ~/.vim
    cd $INSTALL_DIR/dotvim
    make clean
    make
fi
