#!/bin/sh
curl -L https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage -o /tmp/nvim
chmod +x /tmp/nvim
mkdir -p $HOME/.local/bin/
mv /tmp/nvim $HOME/.local/bin/nvim
