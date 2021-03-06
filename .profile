[ -f $HOME/.bashrc ] && . $HOME/.bashrc

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# https://wiki.voidlinux.org/Wayland
if [ -z "${XDG_RUNTIME_DIR}" ]; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir

    if ! [ -d "${XDG_RUNTIME_DIR}" ]; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

export BROWSER="firefox"
export TERMINAL="alacritty"
export EDITOR="nvim"
export FILE="ranger"
export INTERNAL_DISPLAY="LVDS-1"
export EXTERNAL_DISPLAY="VGA-1"
export VPN_PROVIDER="protonvpn"
export GRIM_DEFAULT_DIR="$XDG_CACHE_HOME/screenshots"
export HISTFILE="$XDG_DATA_HOME/bash/history"

export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"     # begin blink
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"     # begin bold
export LESS_TERMCAP_me="$(printf '%b' '[0m')"        # reset bold/blink
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')" # begin reverse video
export LESS_TERMCAP_se="$(printf '%b' '[0m')"        # reset reverse video
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"     # begin underline
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"        # reset underline
export LESSHISTFILE=-

export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_CACHE_HOME/pg/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"

[ -d "${GRIM_DEFAULT_DIR}" ] || mkdir "${GRIM_DEFAULT_DIR}"

if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]; then
    export MOZ_ENABLE_WAYLAND="1"
    export QT_QPA_PLATFORM="wayland-egl"
    export XKB_DEFAULT_LAYOUT=us

    mpd >/dev/null 2>&1
    exec sway
fi

