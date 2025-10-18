#!/bin/bash

# Custom now-playing script for waybar
# More reliable than built-in mpris module

# Check if any player is running
if ! playerctl status &> /dev/null; then
    echo ""
    exit 0
fi

# Get player status
status=$(playerctl status 2>/dev/null)

# Get metadata
artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

# Set icon based on status
if [[ "$status" == "Playing" ]]; then
    icon="♪"
elif [[ "$status" == "Paused" ]]; then
    icon="⏸"
else
    echo ""
    exit 0
fi

# Format output
if [[ -n "$artist" && -n "$title" ]]; then
    # Limit length to prevent waybar overflow
    full_text="$artist - $title"
    if [[ ${#full_text} -gt 40 ]]; then
        full_text="${full_text:0:37}..."
    fi
    echo "$icon $full_text"
elif [[ -n "$title" ]]; then
    if [[ ${#title} -gt 35 ]]; then
        title="${title:0:32}..."
    fi
    echo "$icon $title"
else
    echo ""
fi