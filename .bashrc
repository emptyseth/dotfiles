#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[ -f "$XDG_CONFIG_HOME/aliasrc" ] && source "$XDG_CONFIG_HOME/aliasrc"
PS1='\[\033[38;5;14m\]\w > \[\033[0m\]'
export HISTFILE="$XDG_DATA_HOME"/bash/history

