#!/usr/bin/env python3
"""
Enhanced media player with progress bar and album art support
"""
import subprocess
import json
import sys
import os

PLAYER_PRIORITY_FILE = os.path.expanduser("~/.config/waybar/.selected_player")
CACHE_DIR = os.path.expanduser("~/.cache/waybar-media")

def ensure_cache_dir():
    """Create cache directory for album art"""
    os.makedirs(CACHE_DIR, exist_ok=True)

def get_all_players():
    """Get list of all available media players"""
    try:
        result = subprocess.run(['playerctl', '--list-all'], capture_output=True, text=True)
        if result.returncode == 0:
            return [p.strip() for p in result.stdout.strip().split('\n') if p.strip()]
        return []
    except:
        return []

def get_selected_player():
    """Get the currently selected player from file"""
    try:
        with open(PLAYER_PRIORITY_FILE, 'r') as f:
            return f.read().strip()
    except:
        return None

def set_selected_player(player):
    """Save the selected player to file"""
    try:
        os.makedirs(os.path.dirname(PLAYER_PRIORITY_FILE), exist_ok=True)
        with open(PLAYER_PRIORITY_FILE, 'w') as f:
            f.write(player)
    except:
        pass

def get_metadata(player, key):
    """Get metadata value for a specific key"""
    try:
        cmd = ['playerctl', '--player', player, 'metadata', key]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout.strip() if result.returncode == 0 else ""
    except:
        return ""

def get_position_info(player):
    """Get playback position and length"""
    try:
        # Get position in microseconds
        pos_cmd = ['playerctl', '--player', player, 'position']
        pos_result = subprocess.run(pos_cmd, capture_output=True, text=True)
        position = float(pos_result.stdout.strip()) if pos_result.returncode == 0 else 0

        # Get length from metadata (in microseconds)
        length_cmd = ['playerctl', '--player', player, 'metadata', 'mpris:length']
        length_result = subprocess.run(length_cmd, capture_output=True, text=True)
        length_us = int(length_result.stdout.strip()) if length_result.returncode == 0 else 0
        length = length_us / 1000000  # Convert to seconds

        if length > 0:
            percentage = (position / length) * 100
        else:
            percentage = 0

        return {
            'position': position,
            'length': length,
            'percentage': percentage
        }
    except:
        return {'position': 0, 'length': 0, 'percentage': 0}

def get_album_art(player):
    """Get album art URL and cache it"""
    try:
        art_url = get_metadata(player, 'mpris:artUrl')
        if art_url:
            # Handle file:// URLs
            if art_url.startswith('file://'):
                return art_url[7:]  # Remove file:// prefix
            return art_url
        return None
    except:
        return None

def format_time(seconds):
    """Format seconds to MM:SS"""
    mins = int(seconds // 60)
    secs = int(seconds % 60)
    return f"{mins}:{secs:02d}"

def get_player_icon(player_name):
    """Get icon for player"""
    player_lower = player_name.lower()
    if 'spotify' in player_lower:
        return ''
    elif 'plexamp' in player_lower or 'plex' in player_lower:
        return ''
    elif 'firefox' in player_lower:
        return ''
    elif 'chromium' in player_lower or 'chrome' in player_lower:
        return ''
    elif 'vlc' in player_lower:
        return '󰕼'
    elif 'mpv' in player_lower:
        return ''
    else:
        return '󰎈'

def get_player_info():
    """Get comprehensive player info"""
    players = get_all_players()
    if not players:
        return None

    selected_player = get_selected_player()

    if not selected_player or selected_player not in players:
        selected_player = players[0]
        set_selected_player(selected_player)

    try:
        status_cmd = ['playerctl', '--player', selected_player, 'status']
        status = subprocess.run(status_cmd, capture_output=True, text=True).stdout.strip()

        if not status or status == "No players found":
            return None

        artist = get_metadata(selected_player, 'artist')
        title = get_metadata(selected_player, 'title')
        album = get_metadata(selected_player, 'album')
        album_art = get_album_art(selected_player)
        position_info = get_position_info(selected_player)

        player_icon = get_player_icon(selected_player)

        # Status icons with better Nerd Fonts
        if status == "Playing":
            status_icon = ""  # Play icon
            status_class = "playing"
        elif status == "Paused":
            status_icon = ""  # Pause icon
            status_class = "paused"
        else:
            status_icon = ""  # Stop icon
            status_class = "stopped"

        # Format display text
        if artist and title:
            text = f"{artist} - {title}"
        elif title:
            text = title
        else:
            text = "Unknown"

        # Format time display
        time_display = f"{format_time(position_info['position'])} / {format_time(position_info['length'])}"

        return {
            "text": text,
            "artist": artist,
            "title": title,
            "album": album,
            "status": status,
            "status_icon": status_icon,
            "player_icon": player_icon,
            "player_name": selected_player,
            "class": f"custom-media-{status_class}",
            "percentage": position_info['percentage'],
            "position": position_info['position'],
            "length": position_info['length'],
            "time_display": time_display,
            "album_art": album_art,
            "tooltip": f"{player_icon} {selected_player}\n{artist} - {title}\n{album}\n{time_display}"
        }
    except Exception as e:
        return None

def handle_click(button):
    """Handle mouse clicks"""
    selected_player = get_selected_player()
    if not selected_player:
        return

    if button == "1":  # Left click - play/pause
        subprocess.run(['playerctl', '--player', selected_player, 'play-pause'],
                     capture_output=True)
    elif button == "2":  # Middle click - cycle players
        players = get_all_players()
        if not players:
            return
        current = selected_player
        if current in players:
            current_idx = players.index(current)
            next_idx = (current_idx + 1) % len(players)
            set_selected_player(players[next_idx])
    elif button == "3":  # Right click - next track
        subprocess.run(['playerctl', '--player', selected_player, 'next'],
                     capture_output=True)

def main():
    ensure_cache_dir()

    if len(sys.argv) > 1:
        handle_click(sys.argv[1])
        return

    info = get_player_info()
    if info:
        print(json.dumps(info))
    else:
        players = get_all_players()
        player_list = ", ".join(players) if players else "None"
        print(json.dumps({
            "text": "No Media",
            "status_icon": "󰝚",
            "player_icon": "󰎈",
            "class": "custom-media-stopped",
            "percentage": 0,
            "tooltip": f"Available players: {player_list}"
        }))

if __name__ == "__main__":
    main()
