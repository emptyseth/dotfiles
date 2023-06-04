#!/bin/sh

INDENT_LINE_ICON=''

# Battery or charger
BATTERY_CHARGING_0_ICON='󰢟'
BATTERY_CHARGING_10_ICON='󰢜'
BATTERY_CHARGING_20_ICON='󰂆'
BATTERY_CHARGING_30_ICON='󰂇'
BATTERY_CHARGING_40_ICON='󰂈'
BATTERY_CHARGING_50_ICON='󰢝'
BATTERY_CHARGING_60_ICON='󰂉'
BATTERY_CHARGING_70_ICON='󰢞'
BATTERY_CHARGING_80_ICON='󰂊'
BATTERY_CHARGING_90_ICON='󰂋'
BATTERY_CHARGING_100_ICON='󰂅'

BATTERY_0_ICON='󱃍'
BATTERY_10_ICON='󰁺'
BATTERY_20_ICON='󰁻'
BATTERY_30_ICON='󰁼'
BATTERY_40_ICON='󰁽'
BATTERY_50_ICON='󰁾'
BATTERY_60_ICON='󰁿'
BATTERY_70_ICON='󰂀'
BATTERY_80_ICON='󰂁'
BATTERY_90_ICON='󰂂'
BATTERY_100_ICON='󰁹'

BATTERY_ERROR="󱟩"
get_battery()
{
    bat_icon=$BATTERY_ERROR 
    capacity='0'
    # The vast majority of people only use one battery.
    if [ -d /sys/class/power_supply/BAT0 ]; then
        capacity=$(cat /sys/class/power_supply/BAT0/capacity)
        status=$(cat /sys/class/power_supply/BAT0/status)

        if [ "$status" = "Charging" ]; then
            case $capacity in
                100)    bat_icon=$BATTERY_CHARGING_100_ICON ;;
                9[0-9]) bat_icon=$BATTERY_CHARGING_90_ICON ;;
                8[0-9]) bat_icon=$BATTERY_CHARGING_80_ICON ;;
                7[0-9]) bat_icon=$BATTERY_CHARGING_70_ICON ;;
                6[0-9]) bat_icon=$BATTERY_CHARGING_60_ICON ;;
                5[0-9]) bat_icon=$BATTERY_CHARGING_50_ICON ;;
                4[0-9]) bat_icon=$BATTERY_CHARGING_40_ICON ;;
                3[0-9]) bat_icon=$BATTERY_CHARGING_30_ICON ;;
                2[0-9]) bat_icon=$BATTERY_CHARGING_20_ICON ;;
                1[0-9]) bat_icon=$BATTERY_CHARGING_10_ICON ;;
                [0-9])  bat_icon=$BATTERY_CHARGING_0_ICON ;;
            esac
        else
            case $capacity in
                100)    bat_icon=$BATTERY_100_ICON ;;
                9[0-9]) bat_icon=$BATTERY_90_ICON ;;
                8[0-9]) bat_icon=$BATTERY_80_ICON ;;
                7[0-9]) bat_icon=$BATTERY_70_ICON ;;
                6[0-9]) bat_icon=$BATTERY_60_ICON ;;
                5[0-9]) bat_icon=$BATTERY_50_ICON ;;
                4[0-9]) bat_icon=$BATTERY_40_ICON ;;
                3[0-9]) bat_icon=$BATTERY_30_ICON ;;
                2[0-9]) bat_icon=$BATTERY_20_ICON ;;
                1[0-9]) bat_icon=$BATTERY_10_ICON ;;
                [0-9])  bat_icon=$BATTERY_0_ICON ;;
            esac
        fi
    fi

    echo "$bat_icon $capacity% $INDENT_LINE_ICON"
}


# Prints out the volume percentage
VOLUME_OFF_ICON='󰖁'
VOLUME_LOW_ICON='󰕿'
VOLUME_MEDIUM_ICON='󰖀'
VOLUME_HIGH_ICON='󰕾'
VOLUME_MUTE_ICON='󰝟'
get_volume(){
    mute=$(pamixer --get-mute)
    if [ "$mute" = "true" ]; then
        echo "$VOLUME_MUTE_ICON $INDENT_LINE_ICON"
    else
        volume=$(pamixer --get-volume)

        case $volume in
            7[0-9]|8[0-9]|9[0-9]|100)       volume_icon=$VOLUME_HIGH_ICON ;;
            3[0-9]|4[0-9]|5[0-9]|6[0-9])    volume_icon=$VOLUME_MEDIUM_ICON ;;
            [1-9]|1[0-9]|2[0-9])            volume_icon=$VOLUME_LOW_ICON ;;
            0)                              volume_icon=$VOLUME_OFF_ICON ;;
        esac
        echo "$volume_icon $volume% $INDENT_LINE_ICON"
    fi
}


# Gets the wifi status
WIFI_100_ICON='󰤨'
WIFI_80_ICON='󰤥'
WIFI_60_ICON='󰤢'
WIFI_40_ICON='󰤟'
WIFI_20_ICON='󰤯'
get_wifi()
{
    if [ "$(cat /sys/class/net/wlp3s0/carrier)" = "1" ]; then
        # Wifi quality percentage
        percentage=$(grep "^\s*w" /proc/net/wireless | awk '{ print "", int($3 * 100 / 70)}'| xargs)
        case $percentage in
            100|9[0-9]|8[0-9])  wifi_icon=$WIFI_100_ICON ;;
            7[0-9]|6[0-9])      wifi_icon=$WIFI_80_ICON ;;
            5[0-9]|4[0-9])      wifi_icon=$WIFI_60_ICON ;;
            3[0-9]|2[0-9])      wifi_icon=$WIFI_40_ICON ;;
            1[0-9]|[0-9])       wifi_icon=$WIFI_20_ICON ;;
        esac

        echo "$wifi_icon"
    fi
}

# Prints out if there is an ethernet cable connected
ETHERNET_ICON='󰈀'
get_ethernet()
{
    [ "$(cat /sys/class/net/enp0s25/carrier)" = "1" ] && echo "$ETHERNET_ICON $INDENT_LINE_ICON"
}


# Prints out network status
NETWORK_INACTIVE_ICON="󰌙"
get_network()
{
    # dig available in bind-utils package (voidlinux)
    # ipv4
    current_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
    # ipv6
    [ $current_ip ] || current_ip=$(dig +short AAAA myip.opendns.com @resolver1.opendns.com)

    if [ $current_ip ]; then
        network_status=$(get_wifi)
        [ $network_status ] || network_status=$(get_ethernet)

        echo "$network_status $current_ip $INDENT_LINE_ICON"
    else
        echo "$NETWORK_INACTIVE_ICON $INDENT_LINE_ICON"
    fi
}

# Prints out the date
get_date()
{
    echo "$(date '+%a %d/%m %H:%M')"
}

# Prints out language
get_language()
{
    language=$(swaymsg -r -t get_inputs | grep -m 1 'xkb_active_layout_name' | awk -F '"' '{print $4}')

    if [ "$language" = "Russian" ]; then
        echo "РУС"
    else
        echo "ENG"
    fi
}

# Prints the total ram and used ram in Mb
RAM_ICON='󰍛'
get_ram()
{
    used_ram=$(free -mh --si | awk '/^Mem:/{print $3}')
    echo "$RAM_ICON $used_ram $INDENT_LINE_ICON"
}

# Prints thermal information
TEMP_ICON='󰔄'
get_temperature()
{
    temperature=$(acpi -t | awk '{print $4}')
    echo "$TEMP_ICON $temperature $INDENT_LINE_ICON"
}


PLAY_ICON='󰐊'
PAUSE_ICON='󰏤'
get_mpd()
{
    current_song="$(mpc current)"

    if [ "$current_song" ]; then
        playpause=$(mpc | awk 'NR==2{print $1}')
        player_icon=$PLAY_ICON
        [ "$playpause" = "[paused]" ] && player_icon=$PAUSE_ICON
        echo "$player_icon $current_song $INDENT_LINE_ICON"
    fi
}

# Checks passed output is enabled
is_output_enabled()
{
    echo $(swaymsg -t get_outputs | awk '/name/;/active/' | grep -A1 $1 | grep true)
}

# Enables internal display if external display is unnplugged
enable_internal_display()
{
    [ "$(is_output_enabled $EXTERNAL_DISPLAY)" ] ||
    [ "$(is_output_enabled $INTERNAL_DISPLAY)" ] ||
    swaymsg output $INTERNAL_DISPLAY enable
}

network_status=$(get_network)
battery_status=$(get_battery)
volume_status=$(get_volume)
current_date=$(get_date)
current_language=$(get_language)
current_ram=$(get_ram)
current_temperature=$(get_temperature)
current_song=$(get_mpd)

enable_internal_display &
echo "$current_song $network_status $current_ram $current_temperature $volume_status $battery_status $current_language $current_date "
