#!/bin/bash

current="$HOME/.dotfiles_backup/`date +%Y%m%d%H%M%S`"
mkdir -p "$current"

for var in ".Xdefaults"\
  ".alacritty.yml" \
  ".bash_profile" \
  ".bashrc" \
  ".emacs" \
  ".emacs.d" \
  ".gitconfig" \
  ".gitconfig-personal" \
  ".gitconfig-meta" \
  ".gitignore" \
  ".tmux.conf" \
  ".tmux.conf.local"
do
  if [[ -f "$PWD/${var}" ]]
  then
    cp -HR ~/${var} "$current"
    ln -sf "$PWD/${var}" ~/
  fi
done

if [ ! -f /etc/profile.d/git-prompt.sh ]
then
  echo "# ln -s /usr/share/git-core/contrib/completion/git-prompt.sh  /etc/profile.d/"
fi

