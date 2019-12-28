# Change this according to your device
################
# Variables
################

# Keyboard input name
# keyboard_input_name="1:1:AT_Translated_Set_2_keyboard"

# Date and time
date_and_week=$(date "+%Y-%m-%d")
current_time=$(date "+%H:%M:%S")

#############
# Commands
#############

# Battery or charger
battery_charge=$(acpi | awk '{print $4}')
battery_status=$(acpi | awk '{print $3}')

# Audio and multimedia
#audio_volume=$(pamixer --sink `pactl list sinks short | grep RUNNING | awk '{print $1}'` --get-volume)
#audio_is_muted=$(pamixer --sink `pactl list sinks short | grep RUNNING | awk '{print $1}'` --get-mute)

# Network
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
# interface_easyname grabs the "old" interface name before systemd renamed it
# interface_easyname=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}')
ping=$(ping -c 1 www.google.com | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)

# Others
language=$(swaymsg -r -t get_inputs | awk '/1:1:AT_Translated_Set_2_keyboard/;/xkb_active_layout_name/' | grep -A1 '\b1:1:AT_Translated_Set_2_keyboard\b' | grep "xkb_active_layout_name" | awk -F '"' '{print $4}')

if [ $battery_status = "Charging," ];
then
    battery_pluggedin='⚡'
else
    battery_pluggedin='🔋'
fi

if ! [ $network ]
then
   network_active="⛔"
else
   network_active="⇆"
fi

if [ $audio_is_muted = "true" ]
then
    audio_active='🔇'
else
    audio_active='🔊'
fi

echo "🌐 $language | $network_active $interface_easyname ($ping ms) | $audio_active $audio_volume% | $battery_pluggedin $battery_charge | $date_and_week $current_time"