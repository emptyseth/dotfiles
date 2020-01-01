# .bash_profile

export BROWSER="firefox"
export TERMINAL="alacritty"

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
    #export QT_QPA_PLATFORM="wayland-egl"

    export XKB_DEFAULT_LAYOUT=us 
    exec sway
fi
