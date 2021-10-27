# .bashrc
export BASH_SILENCE_DEPRECATION_WARNING=1

if [ -f /etc/profile ]; then
  . /etc/profile
fi

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

HISTSIZE=100000
HISTFILESIZE=$HISTSIZE
export HISTSIZE
export HISTFILESIZE

if [[ "`uname`" == "Linux" ]]; then
  alias ls='ls --color'
else
  alias ls='ls -G'
fi

# User specific aliases and functions
alias less='less -iX'
alias egrep='grep -E --colour=auto'
alias grep='LC_ALL="C" grep --color'
alias fgrep='LC_ALL="C" fgrep --color'
alias sshnocheck='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias scpnocheck='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias groot='cd "`git rev-parse --show-toplevel`"'

GIT=`which git`

_is_git() {
  [[ -d "./.git" ]] && return 0

  # pretty fast test... an order of magnitude faster than a regular git status
  $GIT status -u no --porcelain=v1 --no-ahead-behind --no-renames --ignore-submodules=all >/dev/null 2>&1
}

_my_git_ps1() {
  _is_git && {
    printf " %s" "$($GIT branch --show-current)"
    [[ $($GIT status --porcelain) ]] && echo '!'
  }
}

_path_if() {
  if [[ -d "$1" ]]; then
    export PATH="${1}:${PATH}"
  fi
}

_path_if "${HOME}/go/bin"
_path_if "${HOME}/.cargo/bin"
_path_if "${HOME}/bin/flatpak"
_path_if "${HOME}/bin"

if ! command -v dirchomp >/dev/null; then
  dirchomp() {
    echo -n "$PWD"
  }
fi

export PS1='\[\033[1;37m\][\[\033[1;32m\]\u\[\033[0m\]@\[\e[0m\]\[\e[1;33m\]\h\[\e[0m\] \[\033[1;34m\]`dirchomp`\[\033[0;35m\]$(_my_git_ps1 " %s")\[\033[1;37m\]]\[\033[0m\] '
if [[ "$USER" == "root" ]]; then
  export PS1='\[\033[1;37m\][\[\033[1;31m\]\u\[\033[0m\]@\[\e[0m\]\[\e[1;33m\]\h\[\e[0m\] \[\033[1;34m\]`dirchomp`\[\033[0;35m\]$(_my_git_ps1 " %s")\[\033[1;37m\]]\[\033[0m\] '
fi

if [[ "$HOSTNAME" =~ "cosmo" ]]; then
  export OLDHOME=/mnt/myth/bak/cosmo/cosmo/home/current/home/iphands
  export OLDROOT=/mnt/myth/bak/cosmo/cosmo/rootfs/current/rootfs
fi

which nodenv >/dev/null 2>&1 && eval "$(nodenv init -)"
which direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export GPG_TTY=$(tty)

if [[ -f "${HOME}/.taniumrc" ]]; then
  source "${HOME}/.taniumrc"
fi

___jumper() {
  if [[ "$PWD" =~ "${HOME}/j/" ]]; then
    if [[ "$PWD" != "${HOME}/j" ]]; then
      local dest
      dest=$(readlink "$PWD")
      echo "jumping to $dest"
      cd "$dest" || return
    fi
  fi
}

if ! [[ "${PROMPT_COMMAND:-}" =~ ___jumper ]]; then
  PROMPT_COMMAND="___jumper${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
