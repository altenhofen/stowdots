# .bashrc

alias cat='bat -pP'
alias uvall='uv sync --all-packages'
alias less='less --RAW-CONTROL-CHARS'
alias ls='ls --color ${LS_OPTS}'
alias grep='rg -uuu -p'
alias v='nvim'
alias vi='nvim'
alias gs='git status -sb'
alias gc='git commit'
alias ga='git add'
alias vim='nvim'
alias ll='ls -alFh'
alias ff='fastfetch'
alias hyprquit='hyprctl dispatch exit'

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

alias osscad='source ~/Downloads/oss-cad-suite/environment'
