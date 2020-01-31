# .bash_profile

export BROWSER="firefox"
export TERMINAL="alacritty"
export FILE="ranger"
export FONT="terminus"
export INTERNAL_DISPLAY="LVDS-1"
export EXTERNAL_DISPLAY="VGA-1"

export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"     # begin blink
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"     # begin bold
export LESS_TERMCAP_me="$(printf '%b' '[0m')"        # reset bold/blink
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')" # begin reverse video
export LESS_TERMCAP_se="$(printf '%b' '[0m')"        # reset reverse video
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"     # begin underline
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"        # reset underline


# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

# https://wiki.voidlinux.org/Wayland
if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir

    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    export BEMENU_BACKEND="wayland"
    export MOZ_ENABLE_WAYLAND="1"
    export QT_QPA_PLATFORM="wayland-egl"

    export XKB_DEFAULT_LAYOUT=us 
    exec sway
fi
