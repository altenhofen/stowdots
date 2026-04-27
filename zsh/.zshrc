#!/bin/zsh

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load
autoload -Uz promptinit && promptinit && prompt pure

source ~/.common.sh
eval "$(~/.local/bin/mise activate)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
