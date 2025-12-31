#!/bin/sh
FONT_NAME=IBMPlexMono

curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/$FONT_NAME.zip --output /tmp/$FONT_NAME.zip && unzip /tmp/$FONT_NAME.zip -d /tmp/$FONT_NAME
mkdir -p $HOME/.local/share/fonts/
cp -i /tmp/$FONT_NAME/*.ttf $HOME/.local/share/fonts/

