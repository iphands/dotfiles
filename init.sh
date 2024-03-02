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

echo
echo "## Bin scripts"
mkdir -p ~/bin
pushd bin >/dev/null
for var in *
do
  echo "-- installing into ~/bin $var"
  ln -sf $PWD ~/bin/$var
done

if [ "$EUID" -eq 0 ]
then
  echo
  echo "## Sbin scripts"
  mkdir -p ~/sbin
  pushd ~/bin >/dev/null
  for var in *
  do
    echo "-- installing into ~/sbin $var"
    ln -sf $PWD ~/sbin/$var
  done
fi

if [ ! -f /etc/profile.d/git-prompt.sh ]
then
  echo "# ln -s /usr/share/git-core/contrib/completion/git-prompt.sh  /etc/profile.d/"
fi
