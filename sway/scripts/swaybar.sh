# Battery or charger
CHARGING_ICON=' '
WARNING_ICON=' '
BATTERY_FULL_ICON=''
BATTERY_2_ICON=''
BATTERY_3_ICON=''
BATTERY_4_ICON=''

FULL_AT=98

BAT_ICON=""
ICON=""

get_battery()
{
	# The vast majority of people only use one battery.

	if [ -d /sys/class/power_supply/BAT0 ]; then
		capacity=$(cat /sys/class/power_supply/BAT0/capacity)
		charging=$(cat /sys/class/power_supply/BAT0/status)
		if [[ "$charging" == "Charging" ]]; then
			ICON="$CHARGING_ICON"
		elif [[ $capacity -le 25 ]]; then
			ICON="$WARNING_ICON"
		fi

		if [[ $capacity -ge $FULL_AT ]]; then
			BAT_ICON=$BATTERY_FULL_ICON
		elif [[ $capacity -le 25 ]]; then
			BAT_ICON=$BATTERY_4_ICON
		elif [[ $capacity -le 60 ]]; then
			BAT_ICON=$BATTERY_3_ICON
		elif [[ $capacity -le $FULL_AT ]]; then
			BAT_ICON=$BATTERY_2_ICON
		fi
	fi
	echo "$ICON$BAT_ICON  $capacity%"
}


# Prints out the volume percentage

VOLUME_ON_ICON=''
VOLUME_MUTED_ICON=''

get_volume(){
        active_sink=$(pacmd list-sinks | awk '/* index:/{print $3}')
        curStatus=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | awk '/muted/{ print $2}')
        volume=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%'| sed s/.$// | tr -d ' ')

        if [ "${curStatus}" = 'yes' ]
        then
            echo "$VOLUME_MUTED_ICON  $volume%"
        else
            echo "$VOLUME_ON_ICON  $volume%"
        fi
}


# Gets the wifi status

WIFI_FULL_ICON=''
WIFI_MID_ICON=''
WIFI_LOW_ICON=''

get_wifi() 
{
        if grep -q wl* "/proc/net/wireless"; then
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
    if [ -d /sys/class/net/eth? ]; then
        if [ "$(cat /sys/class/net/eth?/carrier)" == "1" ]; then
            echo "$ETHERNET_ICON"
        fi
    fi
}


# Prints out the date

get_date()
{
    echo "$(date '+%a %d/%m')"
}


# Prints out network status

NETWORK_INACTIVE_ICON="⛔"

get_network()
{
    network=$(curl -s ifconfig.co)

    if [ $network ]
    then
        echo "$network"
    else
        echo "$NETWORK_INACTIVE_ICON "
    fi
}

# Prints out language

get_language()
{
    language=$(swaymsg -r -t get_inputs | awk '/1:1:AT_Translated_Set_2_keyboard/;/xkb_active_layout_name/' | grep -A1 '\b1:1:AT_Translated_Set_2_keyboard\b' | grep "xkb_active_layout_name" | awk -F '"' '{print $4}')

    if [ $language = "Russian" ];
    then
        echo "РУС"
    else
        echo "ENG"
    fi
}


battery_status=$(get_battery)
volume_status=$(get_volume)
wifi_status=$(get_wifi)
ethernet_status=$(get_ethernet)
network_status=$(get_network)
current_date=$(get_date)
current_language=$(get_language)

echo "$current_language  |  $wifi_status  $ethernet_status  $network_status  |  $volume_status  |  $battery_status  |  $current_date "