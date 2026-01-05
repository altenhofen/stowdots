#!/bin/sh

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/kitten
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
ln -sf ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/kitty.desktop

