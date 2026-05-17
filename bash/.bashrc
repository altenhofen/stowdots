# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi
if [ -f /usr/share/git/git-prompt.sh ]; then
    source /usr/share/git/git-prompt.sh
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH:$HOME/.cargo/bin"
fi
export PATH


# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

alias grep='rg -uuu -p'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias v='nvim'
alias vi='nvim'
alias gs='git status -sb'
alias gc='git commit'
alias ga='git add'


if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

. ~/.bashrc.system
PS_COLOR_RED='\[\033[0;31m\]'
PS_COLOR_GREEN='\[\033[0;32m\]'
PS_COLOR_YELLOW='\[\033[0;33m\]'
PS_COLOR_BLUE='\[\033[0;34m\]'
PS_COLOR_CYAN='\[\033[0;36m\]'
PS_COLOR_WHITE='\[\033[0;37m\]'
PS_COLOR_LIGHT_GRAY='\[\033[0;37m\]'
PS_COLOR_NO_COLOR='\[\033[0m\]' # Reset/End color

export PS1="\
${PS_COLOR_GREEN}[\u@\h] \
${PS_COLOR_BLUE}\w \
${PS_COLOR_YELLOW}\$(__git_ps1 '(%s)')\
${PS_COLOR_NO_COLOR}\n\$ "


alias vim='nvim'
alias ll='ls -alFh'
alias ff='fastfetch'

extract () {
   if [ -f "$1" ] ; then
     case "$1" in
       *.tar.bz2)   tar xjf "$1"    ;;
       *.tar.gz)    tar xzf "$1"    ;;
       *.bz2)       bunzip2 "$1"    ;;
       *.rar)       unrar x "$1"    ;;
       *.gz)        gunzip "$1"     ;;
       *.tar)       tar xf "$1"     ;;
       *.tgz)       tar xzf "$1"    ;;
       *.zip)       unzip "$1"      ;;
       *.Z)         uncompress "$1" ;;
       *.7z)        7z x "$1"       ;;
       *)           echo "'$1' cannot be extracted via extract()" ;;
     esac
   else
     echo "'$1' is not a valid file"
   fi
}

ebook2txt () {
    pandoc -f epub -t plain -o $2 $1
}

cdl () {
  builtin cd "$@" && ll
}

dev () {
  local dir name
  if [ -n "$1" ]; then
    dir="$(cd "$1" && pwd)" || return 1
  else
    dir="$PWD"
  fi

  name="$(basename "$dir" | tr . _ | tr ' ' _)"

  tmux new -A -s "$name" -c "$dir"
}


export PATH=$PATH:$HOME/bin:$HOME/.local/bin

# opencode
export PATH=/home/altenhofen/.opencode/bin:$PATH
