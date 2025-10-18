#!/bin/bash

# Auto-restore session on Hyprland start
SESSION_DIR="$HOME/.config/hypr/sessions"
SESSION_FILE="$SESSION_DIR/last_session.json"

# Wait a bit for Hyprland to fully start
sleep 2

# Check if we should auto-restore (you can add conditions here)
if [[ -f "$SESSION_FILE" ]]; then
    echo "Auto-restoring previous session..."
    ~/.config/hypr/scripts/restore-session.sh
fi