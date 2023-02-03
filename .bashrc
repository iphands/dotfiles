# .bashrc
export BASH_SILENCE_DEPRECATION_WARNING=1

[[ -f /etc/profile ]] && source /etc/profile
[[ -f /etc/bashrc ]] && source /etc/bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

HISTSIZE=1000000
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
alias unfuck_scrolling='tput rmcup'

# Work around odd fluxbox chrome click on menus issue
alias browser='google-chrome-stable --disable-features=SendMouseLeaveEvents'
# alias groot='cd "`git rev-parse --show-toplevel`"'

GIT=`which git`
HG=`which hg 2>/dev/null`

_is_hg() {
  [[ -d "./.hg" ]] && return 0
  HG_STATUS=`timeout 1 $HG status 2>/dev/null`
}

_is_git() {
  [[ -d "./.git" ]] && return 0

  # pretty fast test... an order of magnitude faster than a regular git status
  $GIT status -u no --porcelain=v1 --no-ahead-behind --no-renames --ignore-submodules=all >/dev/null 2>&1
}

groot() {
  _is_git && cd "`git rev-parse --show-toplevel`" && return
  _is_hg  && cd "`hg root`" && return
}

open_modified() {
  _is_hg && emacs -nw `hg st -n --rev .^`
}

_my_git_ps1() {
  _is_git && {
    printf " %s" "$($GIT branch --show-current)"
    $GIT diff --no-ext-diff --quiet || echo -n '*'
    $GIT diff --no-ext-diff --cached --quiet || echo -n '+'
    return
  }

  _is_hg && {
    line=`hg fsl 2>/dev/null | fgrep @ -m1`
    if [[ $line =~ remote/master ]]
    then
      echo " master"
    else
      echo "$line" | grep -Eo ' D[0-9]{4,}'
    fi

    # we already have this set from the _is_hg because bash
    # dont call again
    # HG_STATUS=`$HG status 2>/dev/null`
    echo "$HG_STATUS" | grep -m1 '^[MA!R]' >/dev/null 2>&1 && echo -n "*"
    echo "$HG_STATUS" | grep -m1 ^? >/dev/null 2>&1 && echo -n "+"
    return
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

which direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

export GPG_TTY=$(tty)

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

[[ -f "${HOME}/.asdf" ]] && {
  . "${HOME}/.asdf/asdf.sh"
  . "${HOME}/.asdf/completions/asdf.bash"
}

[[ -z $DISPLAY ]] && export DISPLAY=:0
