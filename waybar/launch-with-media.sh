#!/bin/bash
# Launch waybar with media progress bar

# Kill existing waybar instances
killall waybar 2>/dev/null

# Wait a moment
sleep 0.5

# Launch main waybar
waybar &

# Launch media progress bar waybar
waybar -c ~/.config/waybar/config-media-bar.jsonc -s ~/.config/waybar/configs/"[Current] Waybar Style 2025-10-13.css" &

echo "Waybar launched with media progress bar"
