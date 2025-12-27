# .bash_profile


# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

export LS_OPTS='--color=auto'
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export TERM=xterm-color
export EDITOR=nvim
export BROWSER=firefox

if [ -f ~/.profile ]; then
	. ~/.profile
fi
