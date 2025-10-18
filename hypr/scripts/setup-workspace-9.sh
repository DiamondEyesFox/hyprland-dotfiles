#!/bin/bash
# Setup Workspace 9: Plexamp, cava, cmatrix, neofetch in quadrant layout
# Top-left: Plexamp | Top-right: cmatrix (cyan)
# Bottom-left: cava | Bottom-right: neofetch

sleep 2  # Wait for Hyprland to fully initialize

# Switch to workspace 9
hyprctl dispatch workspace 9

# Launch apps with unique classes
alacritty --class plexamp-term -e plexamp &
sleep 0.3
alacritty --class cava-term -e cava &
sleep 0.3
alacritty --class cmatrix-term -e cmatrix -C cyan &
sleep 0.3
alacritty --class neofetch-term -e sh -c "neofetch && exec bash" &

# Wait for windows to spawn
sleep 1

# Get window addresses by class
PLEXAMP=$(hyprctl clients -j | jq -r '.[] | select(.class=="plexamp-term") | .address')
CAVA=$(hyprctl clients -j | jq -r '.[] | select(.class=="cava-term") | .address')
CMATRIX=$(hyprctl clients -j | jq -r '.[] | select(.class=="cmatrix-term") | .address')
NEOFETCH=$(hyprctl clients -j | jq -r '.[] | select(.class=="neofetch-term") | .address')

# Position windows in quadrant layout
# Top-left: Plexamp (0,0 - 50%x50%)
if [ -n "$PLEXAMP" ]; then
    hyprctl dispatch movewindowpixel exact 0 0,address:$PLEXAMP
    hyprctl dispatch resizewindowpixel exact 50% 50%,address:$PLEXAMP
fi

# Top-right: cmatrix (50%,0 - 50%x50%)
if [ -n "$CMATRIX" ]; then
    hyprctl dispatch movewindowpixel exact 50% 0,address:$CMATRIX
    hyprctl dispatch resizewindowpixel exact 50% 50%,address:$CMATRIX
fi

# Bottom-left: cava (0,50% - 50%x50%)
if [ -n "$CAVA" ]; then
    hyprctl dispatch movewindowpixel exact 0 50%,address:$CAVA
    hyprctl dispatch resizewindowpixel exact 50% 50%,address:$CAVA
fi

# Bottom-right: neofetch (50%,50% - 50%x50%)
if [ -n "$NEOFETCH" ]; then
    hyprctl dispatch movewindowpixel exact 50% 50%,address:$NEOFETCH
    hyprctl dispatch resizewindowpixel exact 50% 50%,address:$NEOFETCH
fi
