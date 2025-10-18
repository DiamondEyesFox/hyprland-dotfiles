#!/bin/bash
# Get current volume
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes\|no")

# Create menu options
options="🔊 Audio Settings
🔇 Toggle Mute ($muted)
🔉 Volume: $volume%
➕ Volume Up (+5%)
➖ Volume Down (-5%)"

# Show rofi menu positioned at top-right (near waybar)
chosen=$(echo "$options" | rofi -dmenu -p "Audio" -location 1 -yoffset 40 -theme-str 'window {width: 250px;}')

case "$chosen" in
    "🔊 Audio Settings") pavucontrol ;;
    "🔇 Toggle Mute"*) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    "➕ Volume Up"*) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    "➖ Volume Down"*) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac