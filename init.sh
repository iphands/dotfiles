#!/bin/bash

current="$HOME/.dotfiles_backup/`date +%Y%m%d%H%M%S`"
mkdir -p $current

for var in ".emacs" ".emacs.d" ".bashrc" ".bash_profile"
do
	cp -Hr ~/${var} $current
	ln -sf $PWD/${var} ~/
done

