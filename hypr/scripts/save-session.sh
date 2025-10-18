#!/bin/bash

# Hyprland Session Saver
# Saves current window layout and workspace configuration

SESSION_DIR="$HOME/.config/hypr/sessions"
SESSION_FILE="$SESSION_DIR/last_session.json"
WINDOW_DATA_FILE="$SESSION_DIR/windows.txt"

# Create session directory
mkdir -p "$SESSION_DIR"

echo "Saving Hyprland session..."

# Get all windows with their properties
hyprctl clients -j > "$SESSION_FILE"

# Also save a human-readable format
{
    echo "# Hyprland Session Save - $(date)"
    echo "# Format: workspace|class|title|position|size|monitor"
    echo ""
    
    hyprctl clients -j | jq -r '.[] | 
        "\(.workspace.id)|\(.class)|\(.title)|\(.at[0]),\(.at[1])|\(.size[0])x\(.size[1])|\(.monitor)"'
} > "$WINDOW_DATA_FILE"

# Save workspace information
hyprctl workspaces -j > "$SESSION_DIR/workspaces.json"

# Save active workspace
hyprctl activeworkspace -j > "$SESSION_DIR/active_workspace.json"

echo "Session saved to $SESSION_DIR"
echo "Windows: $(jq length "$SESSION_FILE")"
echo "Workspaces: $(jq length "$SESSION_DIR/workspaces.json")"