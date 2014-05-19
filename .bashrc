# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

EDITOR='/usr/bin/emacs -nw'
HISTSIZE=100000

# User specific aliases and functions
alias less='less -iX'
alias ls='ls --color'
alias grep='LC_ALL="C" grep --color'
alias fgrep='LC_ALL="C" fgrep --color'

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

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

