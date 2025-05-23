#!/bin/sh

# Toggles VPN connection

# toggle_vpn()
# {
#     if [ "$VPN_PROVIDER" = 'protonvpn' ]; then
#         vpn_status=$(protonvpn status | awk '/Status/{print $2}')

#         if [ "$vpn_status" = "Connected" ]; then
#             notify-send 'Disconnecting VPN...' & sudo protonvpn disconnect | while read result; do notify-send "$result"; done
#         else
#             notify-send 'Connecting VPN...' & sudo protonvpn connect -f | while read result; do notify-send "$result"; done
#         fi
#     fi
# }

enable_vpn()
{
    if [ "$VPN_PROVIDER" = 'protonvpn' ]; then
        "${TERM:-alacritty}" -e bash -c 'sudo protonvpn c'
    fi
}

enable_vpn
