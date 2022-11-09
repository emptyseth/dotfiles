[ -f $HOME/.bashrc ] && . $HOME/.bashrc

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export BROWSER="firefox"
export TERMINAL="alacritty"
export EDITOR="nvim"
export FILE="ranger"
export INTERNAL_DISPLAY="LVDS-1"
export EXTERNAL_DISPLAY="VGA-1"
export VPN_PROVIDER="protonvpn"

export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"       # begin blink
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"       # begin bold
export LESS_TERMCAP_me="$(printf '%b' '[0m')"          # reset bold/blink
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"   # begin reverse video
export LESS_TERMCAP_se="$(printf '%b' '[0m')"          # reset reverse video
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"       # begin underline
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"          # reset underline
export LESSHISTFILE=-

# read https://wiki.archlinux.org/title/XDG_Base_Directory
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_CACHE_HOME/pg/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export GOPATH="$XDG_DATA_HOME/go"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]; then
    export MOZ_ENABLE_WAYLAND="1"
    export QT_QPA_PLATFORM="wayland-egl"
    export XKB_DEFAULT_LAYOUT=us

    mpd >/dev/null 2>&1
    exec sway
fi
