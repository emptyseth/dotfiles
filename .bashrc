#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[ -f "$XDG_CONFIG_HOME/aliasrc" ] && source "$XDG_CONFIG_HOME/aliasrc"

PS1='\[\033[38;5;14m\]\w > \[\033[0m\]'

export NVM_DIR="$XDG_CONFIG_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
