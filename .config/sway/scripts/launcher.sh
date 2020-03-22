#!/bin/sh

# Starts launcher

start_launcher()
{
    [ "$TERMINAL" = 'alacritty' ] && alacritty --config-file ~/.config/alacritty/launcher.yml -e bash -c 'compgen -c | grep -v fzf | sort -u | fzf --layout=reverse | xargs -r swaymsg -t command exec'
}

start_launcher

