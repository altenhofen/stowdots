# .bash_profile


# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
if uwsm check may-start && uwsm select; then
	exec uwsm start hyprland.desktop
fi
