#!/bin/bash

# Hyprland logout script with proper cleanup

# Kill hyprsession first to save session
if pgrep hyprsession > /dev/null; then
    killall hyprsession
    sleep 1
fi

# Kill waybar and other Hyprland-specific processes
killall waybar hyprpaper swaync 2>/dev/null

# Give processes time to cleanup
sleep 2

# Terminate the session cleanly
loginctl terminate-session "$XDG_SESSION_ID"