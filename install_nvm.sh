#!/bin/sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source $HOME/.bashrc
nvm install --lts
nvm install -g tree-sitter-cli
