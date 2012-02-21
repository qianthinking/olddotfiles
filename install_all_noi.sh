#!/bin/bash
wget https://raw.github.com/qianthinking/dotfiles/master/install_all_with_interactive_shell.sh -O /tmp/install_all.sh
chmod a+x /tmp/install_all.sh
echo "please execute `tput setaf 2; tput bold`/tmp/install_all.sh`tput sgr0` manually"
