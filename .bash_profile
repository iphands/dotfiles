# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]
then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH

EDITOR='/usr/bin/emacs -nw'
export EDITOR

if [ -f ~/.profile]
then
    source ~/.profile
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
