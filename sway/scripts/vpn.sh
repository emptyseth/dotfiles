#!/bin/sh

# Toggles VPN connection 

toggle_vpn()
{
    vpn_status=$(protonvpn status | awk '/Status/{print $2}')

    if [ "$vpn_status" = "Connected" ]; then
        echo $(notify-send 'Disconnecting VPN...' && sudo protonvpn disconnect) | while read result; do notify-send "$result"; done
    else
        echo $(notify-send 'Connecting VPN...' && sudo protonvpn connect -f) | while read result; do notify-send "$result"; done
    fi
}

toggle_vpn
