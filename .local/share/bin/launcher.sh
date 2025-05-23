#!/bin/sh

# Starts launcher

start_launcher()
{
    case "$TERM" in
        alacritty)
            alacritty --class com.emptyseth.launcher -e bash -c 'compgen -c | grep -v fzf | sort -u | fzf --layout=reverse | xargs -r swaymsg -t command exec'
            ;;
        ghostty)
            ghostty --class=com.emptyseth.launcher -e "bash -c 'compgen -c | grep -v fzf | sort -u | fzf --layout=reverse | xargs -r swaymsg -t command exec'"
            ;;
        *)
            # Default to alacritty if TERM is not set or recognized
            "${TERM:-alacritty}" --class com.emptyseth.launcher -e bash -c 'compgen -c | grep -v fzf | sort -u | fzf --layout=reverse | xargs -r swaymsg -t command exec'
            ;;
    esac
}

start_launcher

