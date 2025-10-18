#!/bin/bash
# Setup Workspace 10: waypaper (left), btop (right)

sleep 2  # Wait for Hyprland to fully initialize

# Switch to workspace 10
hyprctl dispatch workspace 10

# Launch apps with unique classes
waypaper &
sleep 0.3
alacritty --class btop-term -e btop &

# Wait for windows to spawn
sleep 1

# Get window addresses by class
WAYPAPER=$(hyprctl clients -j | jq -r '.[] | select(.class=="waypaper") | .address')
BTOP=$(hyprctl clients -j | jq -r '.[] | select(.class=="btop-term") | .address')

# Position windows side by side
# Left: waypaper (0,0 - 50%x100%)
if [ -n "$WAYPAPER" ]; then
    hyprctl dispatch movewindowpixel exact 0 0,address:$WAYPAPER
    hyprctl dispatch resizewindowpixel exact 50% 100%,address:$WAYPAPER
fi

# Right: btop (50%,0 - 50%x100%)
if [ -n "$BTOP" ]; then
    hyprctl dispatch movewindowpixel exact 50% 0,address:$BTOP
    hyprctl dispatch resizewindowpixel exact 50% 100%,address:$BTOP
fi
