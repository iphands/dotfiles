# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

HISTSIZE=100000
export HISTSIZE

HISTFILESIZE=$HISTSIZE
export HISTFILESIZE

# User specific aliases and functions
alias less='less -iX'
alias ls='ls --color'
alias grep='LC_ALL="C" grep --color'
alias fgrep='LC_ALL="C" fgrep --color'
alias yum='dnf'
alias sshnocheck='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias chode='chown'
alias git-tug='git pull && git pull --rebase'
alias term='konsole'

# export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
source /usr/local/share/git-prompt.sh

if [ $UID -eq 0 ]
then
	export PS1='\[\033[1;37m\][\[\033[1;31m\]\u\[\033[0m\]@\[\e[0m\]\[\e[1;33m\]\h\[\e[0m\] \[\033[1;34m\]\w\[\033[0;35m\]$(__git_ps1 " %s")\[\033[1;37m\]]\[\033[0m\] '
else
	export PS1='\[\033[1;37m\][\[\033[1;32m\]\u\[\033[0m\]@\[\e[0m\]\[\e[1;33m\]\h\[\e[0m\] \[\033[1;34m\]\w\[\033[0;35m\]$(__git_ps1 " %s")\[\033[1;37m\]]\[\033[0m\] '
fi



# source files for work
if [ -f ~/.bashrc_redhat ]
then
    . ~/.bashrc_redhat
fi

export PATH="$PATH:$HOME/bin/:/usr/local/cuda-8.0/bin"
export OLDHOME=/mnt/myth/bak/cosmo/cosmo/home/current/home/iphands
export OLDROOT=/mnt/myth/bak/cosmo/cosmo/rootfs/current/rootfs



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
