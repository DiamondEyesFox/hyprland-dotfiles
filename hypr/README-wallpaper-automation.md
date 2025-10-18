# Wallpaper Color Scheme Automation

This setup automatically generates color schemes using both **matugen** and **pywal** whenever you change your wallpaper.

## Components

### 1. Wallpaper Watcher Script
**Location:** `~/.config/hypr/scripts/wallpaper-watcher.sh`

- Monitors `hyprpaper.conf` for changes using inotifywait
- Automatically runs matugen and pywal when wallpaper changes
- Reloads waybar to apply new colors
- Starts automatically on login via Hyprland config

### 2. Manual Wallpaper Switcher
**Location:** `~/.config/hypr/scripts/wallpaper-switcher.sh`

- Interactive wallpaper selector using rofi
- Runs both matugen and pywal when you select a wallpaper
- Updates hyprpaper config
- Restarts hyprpaper and waybar

**Usage:**
```bash
~/.config/hypr/scripts/wallpaper-switcher.sh
```

### 3. Auto-Start Configuration
**Location:** `~/.config/hypr/hyprland.conf`

The watcher starts automatically on login:
```
exec-once = ~/.config/hypr/scripts/wallpaper-watcher.sh
```

## How It Works

1. When you change wallpaper (via waypaper, wallpaper-switcher, or any other tool)
2. The watcher detects the change in `hyprpaper.conf`
3. Both color scheme generators run:
   - **matugen**: Generates Material You themed colors
   - **pywal**: Generates color schemes from the wallpaper
4. Waybar reloads to apply the new colors

## Supported Wallpaper Managers

- hyprpaper (primary)
- waypaper (GUI wallpaper selector)
- Manual wallpaper-switcher script

## Manual Testing

To test the automation:
```bash
# Change wallpaper manually
echo "preload = /path/to/wallpaper.png" > ~/.config/hypr/hyprpaper.conf
echo "wallpaper = ,/path/to/wallpaper.png" >> ~/.config/hypr/hyprpaper.conf
echo "" >> ~/.config/hypr/hyprpaper.conf
echo "splash = false" >> ~/.config/hypr/hyprpaper.conf
echo "ipc = on" >> ~/.config/hypr/hyprpaper.conf

# Watch for automatic color generation
```

## Color Scheme Locations

- **Pywal cache:** `~/.cache/wal/`
- **Matugen output:** Check matugen config for output location

## Troubleshooting

Check if watcher is running:
```bash
pgrep -f wallpaper-watcher
```

View watcher logs:
```bash
# The watcher runs in background, no log file by default
# You can modify the script to log to a file if needed
```

Restart watcher:
```bash
pkill -f wallpaper-watcher
~/.config/hypr/scripts/wallpaper-watcher.sh &
```

## Dependencies

- `inotify-tools` - File system monitoring
- `matugen` - Material You color generation
- `pywal` (wal) - Color scheme generation from images
- `hyprpaper` - Wallpaper manager for Hyprland
