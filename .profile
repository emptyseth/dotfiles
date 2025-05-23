# ~/.profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

export BROWSER="firefox"
export TERM="ghostty"
export EDITOR="code-oss"
export FILE="yazi"
export INTERNAL_DISPLAY="LVDS-1"
export EXTERNAL_DISPLAY="VGA-1"
export VPN_PROVIDER="protonvpn"
export GTK_THEME="Breeze-Dark"
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_QPA_PLATFORM="wayland-egl"
export FONT="terminus"

# Theme
export COLOR_ROSEWATER="#f4dbd6"
export COLOR_FLAMINGO="#f0c6c6"
export COLOR_PINK="#f5bde6"
export COLOR_MAUVE="#c6a0f6"
export COLOR_RED="#ed8796"
export COLOR_MAROON="#ee99a0"
export COLOR_PEACH="#f5a97f"
export COLOR_YELLOW="#eed49f"
export COLOR_GREEN="#a6da95"
export COLOR_TEAL="#8bd5ca"
export COLOR_SKY="#91d7e3"
export COLOR_SAPPHIRE="#7dc4e4"
export COLOR_BLUE="#8aadf4"
export COLOR_LAVENDER="#b7bdf8"
export COLOR_TEXT="#cad3f5"
export COLOR_SUBTEXT1="#b8c0e0"
export COLOR_SUBTEXT0="#a5adcb"
export COLOR_OVERLAY2="#939ab7"
export COLOR_OVERLAY1="#8087a2"
export COLOR_OVERLAY0="#6e738d"
export COLOR_SURFACE2="#5b6078"
export COLOR_SURFACE1="#494d64"
export COLOR_SURFACE0="#363a4f"
export COLOR_BASE="#24273a"
export COLOR_MANTLE="#1e2030"
export COLOR_CRUST="#181926"

export FZF_DEFAULT_OPTS=" \
--color=bg+:$COLOR_SURFACE0,bg:$COLOR_BASE,spinner:$COLOR_ROSEWATER,hl:$COLOR_RED \
--color=fg:$COLOR_TEXT,header:$COLOR_RED,info:$COLOR_MAUVE,pointer:$COLOR_ROSEWATER \
--color=marker:$COLOR_LAVENDER,fg+:$COLOR_TEXT,prompt:$COLOR_MAUVE,hl+:$COLOR_RED \
--color=selected-bg:$COLOR_SURFACE1 \
--color=border:$COLOR_SURFACE0,label:$COLOR_TEXT"

# Read https://wiki.archlinux.org/title/XDG_Base_Directory
export XKB_DEFAULT_LAYOUT="us"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/pg/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export GOPATH="$XDG_DATA_HOME/go"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export GPG_TTY="$(tty)"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"       # begin blink
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"       # begin bold
export LESS_TERMCAP_me="$(printf '%b' '[0m')"          # reset bold/blink
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"   # begin reverse video
export LESS_TERMCAP_se="$(printf '%b' '[0m')"          # reset reverse video
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"       # begin underline
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"          # reset underline
export LESSHISTFILE=-

if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]; then
    export XDG_CURRENT_DESKTOP="sway"
    export MOZ_DBUS_REMOTE=1
    export GTK_USE_PORTAL=0 
    export WOBSOCK=$XDG_RUNTIME_DIR/wob.sock

    exec dbus-run-session sway
fi

. "$HOME/.local/share/../bin/env"
