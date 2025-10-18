#!/bin/bash

# Exit Hyprland with session save
# This script saves the current session before exiting Hyprland

echo "Saving session before exit..."
~/.config/hypr/scripts/save-session.sh

# Give the save operation time to complete
sleep 1

echo "Exiting Hyprland..."
hyprctl dispatch exit
