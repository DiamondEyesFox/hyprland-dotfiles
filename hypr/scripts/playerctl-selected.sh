#!/bin/bash
# Execute playerctl command on the currently selected player from waybar

PLAYER_FILE="$HOME/.config/waybar/.selected_player"

# Get the selected player
if [ -f "$PLAYER_FILE" ]; then
    SELECTED_PLAYER=$(cat "$PLAYER_FILE")
    if [ -n "$SELECTED_PLAYER" ]; then
        playerctl --player="$SELECTED_PLAYER" "$@"
        exit 0
    fi
fi

# Fallback to default playerctl behavior if no player selected
playerctl "$@"
