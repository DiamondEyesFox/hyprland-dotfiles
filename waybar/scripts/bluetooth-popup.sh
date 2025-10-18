#!/bin/bash
# Get bluetooth status
bt_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
connected_devices=$(bluetoothctl devices Connected | wc -l)

# Create menu options
options="🔧 Bluetooth Manager
🔘 Toggle Bluetooth ($bt_status)
📡 Scan for Devices
🔗 Connected: $connected_devices devices"

# Add connected devices to disconnect option
if [ "$connected_devices" -gt 0 ]; then
    options="$options
❌ Disconnect All"
fi

# Show recent devices for quick connect
recent_devices=$(bluetoothctl devices | head -3)
if [ ! -z "$recent_devices" ]; then
    options="$options
--- Recent Devices ---"
    while IFS= read -r device; do
        device_name=$(echo "$device" | cut -d' ' -f3-)
        device_mac=$(echo "$device" | cut -d' ' -f2)
        options="$options
🎧 Connect: $device_name"
    done <<< "$recent_devices"
fi

# Show rofi menu
chosen=$(echo "$options" | rofi -dmenu -p "Bluetooth" -location 1 -yoffset 40 -theme-str 'window {width: 300px;}')

case "$chosen" in
    "🔧 Bluetooth Manager") blueman-manager ;;
    "🔘 Toggle Bluetooth"*) 
        if [ "$bt_status" = "yes" ]; then
            bluetoothctl power off
        else
            bluetoothctl power on
        fi ;;
    "📡 Scan for Devices") 
        bluetoothctl scan on &
        notify-send "Bluetooth" "Scanning for devices..." ;;
    "❌ Disconnect All") 
        bluetoothctl devices Connected | while read device; do
            mac=$(echo "$device" | cut -d' ' -f2)
            bluetoothctl disconnect "$mac"
        done ;;
    "🎧 Connect:"*)
        device_name=$(echo "$chosen" | cut -d':' -f2- | xargs)
        device_mac=$(bluetoothctl devices | grep "$device_name" | cut -d' ' -f2)
        bluetoothctl connect "$device_mac" ;;
esac