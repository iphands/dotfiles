# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]
then
    . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH

EDITOR=emacs
export EDITOR

if [ -f ~/.profile ]
then
    source ~/.profile
fi

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
