#!/bin/bash
INSTALL_DIR=${INSTALL_DIR:-~/.config_all}
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

#install git-prompt
if [ -d "$INSTALL_DIR/git-prompt" ]; then
    cd $INSTALL_DIR/git-prompt
    git pull
else
    git clone git://github.com/qianthinking/git-prompt.git
    ./git-prompt/git-prompt.sh
    ln -fns $INSTALL_DIR/git-prompt/git-prompt.conf ~/.git-prompt.conf
fi

#install tmux
if [ -d "$INSTALL_DIR/dotfiles" ]; then
    cd $INSTALL_DIR/dotfiles
    git pull
    echo "please check $INSTALL_DIR/dotfiles/.bashrc.addon for update"
else
    git clone git://github.com/qianthinking/dotfiles.git
    ln -fns $INSTALL_DIR/dotfiles/.gitconfig ~/.gitconfig
    ln -fns $INSTALL_DIR/dotfiles/.tmux.conf ~/.tmux.conf
    ln -fns $INSTALL_DIR/dotfiles/.pentadactylrc ~/.pentadactylrc
    cat $INSTALL_DIR/dotfiles/.bashrc.addon >> ~/.bashrc
    echo "[[ \$- == *i* ]] && . $INSTALL_DIR/git-prompt/git-prompt.sh" >> ~/.bash_profile
fi

REQUIRE_INPUT=true
while $REQUIRE_INPUT; do
    read -p "Do you wish to install this vim config into ~/.vim and ~/.vimrc(old files will be renamed with time suffix)?" yn
    case $yn in
        [Yy]* ) 
            mv ~/.vim{,.`date +%F_%T`} 2>/dev/null
            mv ~/.vimrc{,.`date +%F_%T`} 2>/dev/null
            mv ~/.gvimrc{,.`date +%F_%T`} 2>/dev/null
            git clone git://github.com/qianthinking/dotvim.git ~/.vim
            cd ~/.vim
            make
            REQUIRE_INPUT=false
            ;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
