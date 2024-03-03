#!/bin/bash

current="$HOME/.dotfiles_backup/`date +%Y%m%d%H%M%S`"
mkdir -p "$current"

echo "## Dotfiles"
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
    echo "-- installing $var"
    cp -HR ~/${var} "$current"
    ln -sf "$PWD/${var}" ~/
  fi
done

install() {
  p=$1
  echo
  echo "## $p scripts"
  mkdir -p ~/$p
  pushd ./$p >/dev/null
  for var in *
  do
    echo "-- installing ~/$p/$var"
    ln -sf $PWD/$var ~/$p/
  done
  popd >/dev/null
}

install bin

if [ "$EUID" -eq 0 ]
then
  install sbin
fi


if [ ! -f /etc/profile.d/git-prompt.sh ]
then
  echo "# ln -s /usr/share/git-core/contrib/completion/git-prompt.sh  /etc/profile.d/"
fi
