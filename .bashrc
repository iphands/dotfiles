# .bashrc
export BASH_SILENCE_DEPRECATION_WARNING=1

# Source global definitions
# if [ -f /etc/bashrc ]; then
#     . /etc/bashrc
# fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

HISTSIZE=100000
export HISTSIZE

HISTFILESIZE=$HISTSIZE
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

get_pwd() {
  d=$(echo "$PWD" | sed -e "s|$HOME|~|")
  if [ ${#d} -gt 25 ]
  then
    echo $(echo "$d" | sed -e "s|\([^/]\)[^/]*/|\1/|g")
  else
    echo "$d"
  fi
}


export PS1='\[\033[1;37m\][\[\033[1;32m\]\u\[\033[0m\]@\[\e[0m\]\[\e[1;33m\]\h\[\e[0m\] \[\033[1;34m\]`dirchomp`\[\033[0;35m\]$(__git_ps1 " %s")\[\033[1;37m\]]\[\033[0m\] '
if [[ "$USER" == "root" ]]; then
  export PS1='\[\033[1;37m\][\[\033[1;31m\]\u\[\033[0m\]@\[\e[0m\]\[\e[1;33m\]\h\[\e[0m\] \[\033[1;34m\]`dirchomp`\[\033[0;35m\]$(__git_ps1 " %s")\[\033[1;37m\]]\[\033[0m\] '
fi

# export PATH="$PATH:$HOME/bin/:/usr/local/cuda-8.0/bin"
# export PATH="$PATH:${HOME}/.nodenv/versions/12.18.0/bin"
export PATH="$PATH:${HOME}/go/bin"
export PATH="${HOME}/.cargo/bin:$PATH"

if [[ "$HOSTNAME" =~ "cosmo" ]]; then
  export OLDHOME=/mnt/myth/bak/cosmo/cosmo/home/current/home/iphands
  export OLDROOT=/mnt/myth/bak/cosmo/cosmo/rootfs/current/rootfs
fi

which nodenv >/dev/null 2>&1 && eval "$(nodenv init -)"
which direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

export GPG_TTY=$(tty)

if [[ -f "${HOME}/.taniumrc" ]]; then
  source "${HOME}/.taniumrc"
fi
