#!/bin/sh

# Battery or charger
CHARGING_ICON=''
WARNING_ICON=''

BATTERY_10_ICON=''
BATTERY_30_ICON=''
BATTERY_60_ICON=''
BATTERY_90_ICON=''
BATTERY_100_ICON=''


BAT_ICON=""
ICON=""

get_battery()
{
	# The vast majority of people only use one battery.
	if [ -d /sys/class/power_supply/BAT0 ]; then
		capacity=$(cat /sys/class/power_supply/BAT0/capacity)
		status=$(cat /sys/class/power_supply/BAT0/status)

		if [ "$status" = "Charging" ]; then
			ICON="$CHARGING_ICON "
		elif [ $capacity -le 25 ]; then
			ICON="$WARNING_ICON "
		fi

                case $capacity in
                        100|9[7-9])             BAT_ICON=$BATTERY_100_ICON ;;
                        7[0-9]|8[0-9]|9[0-7])   BAT_ICON=$BATTERY_90_ICON ;;
                        4[0-9]|5[0-9]|6[0-9])   BAT_ICON=$BATTERY_60_ICON ;;
                        1[0-9]|2[0-9]|3[0-9])   BAT_ICON=$BATTERY_30_ICON ;;
                        [0-9])                  BAT_ICON=$BATTERY_10_ICON ;;
                esac
	fi
	echo "$ICON$BAT_ICON $capacity%"
}


# Prints out the volume percentage

VOLUME_ON_ICON=''
VOLUME_MUTED_ICON=''

get_volume(){
    active_sink=$(pacmd list-sinks | awk '/* index:/{print $3}')
    is_muted=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | awk '/muted/{ print $2}')
    volume=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%'| sed s/.$// | tr -d ' ')
    volume_icon=$VOLUME_ON_ICON
    [ "$is_muted" ] && volume_icon=$VOLUME_MUTED_ICON
    echo "$volume_icon $volume%"
}


# Gets the wifi status

WIFI_FULL_ICON=''
WIFI_MID_ICON=''
WIFI_LOW_ICON=''

get_wifi()
{
    if [ "$(cat /sys/class/net/wlp3s0/carrier)" = "1" ]; then
        # Wifi quality percentage
        percentage=$(grep "^\s*w" /proc/net/wireless | awk '{ print "", int($3 * 100 / 70)}'| xargs)
        case $percentage in
                100|9[0-9]|8[0-9]|7[0-9])       echo "$WIFI_FULL_ICON" ;;
                6[0-9]|5[0-9]|4[0-9]|3[0-9])    echo "$WIFI_MID_ICON" ;;
                2[0-9]|1[0-9]|[0-9])            echo "$WIFI_LOW_ICON" ;;
        esac
    fi
}

# Prints out if there is an ethernet cable connected

ETHERNET_ICON=''

get_ethernet()
{
    [ "$(cat /sys/class/net/enp0s25/carrier)" = "1" ] && echo "$ETHERNET_ICON"
}


# Prints out the date

get_date()
{
    echo "$(date '+%a %d/%m %H:%M')"
}


# Prints out network status

NETWORK_INACTIVE_ICON="⛔"

get_network()
{
    # dig available in bind-utils package (voidlinux)
    current_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)

    if [ $current_ip ]; then
        network_status=$(get_wifi)
        [ $network_status ] || network_status=$(get_ethernet)

        echo "$network_status $current_ip"
    else
        echo "$NETWORK_INACTIVE_ICON"
    fi
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

RAM_ICON=''

get_ram()
{
    used_ram=$(free -mh --si | awk '/^Mem:/{print $3}')
    echo "$RAM_ICON $used_ram"
}


# Prints thermal information

TEMP_ICON=''

get_temperature()
{
    temperature=$(acpi -t | awk '{print $4}')
    echo "$TEMP_ICON $temperature°C"
}


PLAY_ICON=''
PAUSE_ICON=''

get_mpd()
{
    current_song="$(mpc current)"

    if [ "$current_song" ]; then
        playpause=$(mpc | awk 'NR==2{print $1}')
        player_icon=$PLAY_ICON
        [ "$playpause" = "[paused]" ] && player_icon=$PAUSE_ICON
    fi

    echo "$player_icon $current_song"
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

echo "$current_song  $current_language  $current_ram  $current_temperature  $network_status  $volume_status  $battery_status  $current_date "

