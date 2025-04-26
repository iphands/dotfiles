#!/bin/bash
set -e

current="$HOME/.dotfiles_backup/`date +%Y%m%d%H%M%S`"
mkdir -p "$current"

install_scripts() {
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

install_host() {
  git_target=$1
  target=$2
  if [[ "$HOSTNAME" =~ "PC2K41CN" ]]
  then
    host=handslap
  elif [[ "$HOSTNAME" =~ "cosmo" ]]
  then
    host=cosmo
  else
    return 0
  fi

  pushd host/$host/$git_target >/dev/null
  mkdir -p ~/$target
  for var in *
  do
    echo "-- installing ~/$target/$var"
    ln -sf $PWD/$var ~/$target/$var
  done
  popd >/dev/null
}

echo "## Dotfiles"
for var in ".Xdefaults"\
  ".alacritty.toml" \
  ".bash_profile" \
  ".bashrc" \
  ".emacs" \
  ".emacs.d" \
  ".gitconfig" \
  ".gitconfig-meta" \
  ".gitignore" \
  ".tmux.conf" \
  ".tmux.conf.local"
do
  echo "-- installing $var"
  if [[ -f ~/${var} ]]
  then
    cp -HR ~/${var} "$current"
  fi
  ln -sf "$PWD/${var}" ~/
done

install_scripts bin

if [ "$EUID" -eq 0 ]
then
  install_scripts sbin
fi

echo
echo "## Host specific"
install_host fluxbox .fluxbox

# if [ ! -f /etc/profile.d/git-prompt.sh ]
# then
#   echo "# ln -s /usr/share/git-core/contrib/completion/git-prompt.sh  /etc/profile.d/"
# fi
