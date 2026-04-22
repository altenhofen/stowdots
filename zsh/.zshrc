#!/bin/zsh

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load
autoload -Uz promptinit && promptinit && prompt pure
