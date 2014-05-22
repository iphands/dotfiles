#!/bin/bash

current="$HOME/.dotfiles_backup/`date +%Y%m%d%H%M%S`"
mkdir -p $current

for var in ".emacs" ".emacs.d" ".bashrc" ".bash_profile" ".Xdefaults"
do
	cp -Hr ~/${var} $current
	ln -sf $PWD/${var} ~/
done

if [ ! -f /etc/profile.d/git-prompt.sh ]
then
	echo "# ln -s /usr/share/git-core/contrib/completion/git-prompt.sh  /etc/profile.d/"
fi

