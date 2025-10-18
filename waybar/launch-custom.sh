#!/bin/bash
# Launch Waybar with custom config

# Kill existing waybar
killall waybar 2>/dev/null

# Wait for processes to end
sleep 1

# Launch with custom config
waybar -c ~/.config/waybar/custom/config.json -s ~/.config/waybar/custom/style.css &

echo "Waybar launched with custom config!"