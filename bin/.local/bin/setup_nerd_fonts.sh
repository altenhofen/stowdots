FONT=CascadiaCode

curl -o /tmp/$FONT.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/$FONT.zip

unzip /tmp/$FONT.zip -d ~/.local/share/fonts/

fc-cache -vf ~/.local/share/fonts/

echo "installed $FONT font"
