#!/usr/bin/env python3
import subprocess
import json
import sys
import os

PLAYER_PRIORITY_FILE = os.path.expanduser("~/.config/waybar/.selected_player")

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

def cycle_player():
    """Cycle to the next available player"""
    players = get_all_players()
    if not players:
        return
    
    current = get_selected_player()
    if current and current in players:
        current_idx = players.index(current)
        next_idx = (current_idx + 1) % len(players)
        set_selected_player(players[next_idx])
    else:
        set_selected_player(players[0])

def get_player_info():
    players = get_all_players()
    if not players:
        return None
    
    selected_player = get_selected_player()
    
    # If no player selected or selected player not available, use first available
    if not selected_player or selected_player not in players:
        selected_player = players[0]
        set_selected_player(selected_player)
    
    try:
        # Get player status
        status_cmd = ['playerctl', '--player', selected_player, 'status']
        status = subprocess.run(status_cmd, capture_output=True, text=True).stdout.strip()
        
        if not status or status == "No players found":
            return None
            
        # Get track info
        artist_cmd = ['playerctl', '--player', selected_player, 'metadata', 'artist']
        title_cmd = ['playerctl', '--player', selected_player, 'metadata', 'title']
        
        artist = subprocess.run(artist_cmd, capture_output=True, text=True).stdout.strip()
        title = subprocess.run(title_cmd, capture_output=True, text=True).stdout.strip()
        
        # Determine icon and player name
        player_name = selected_player
        if 'spotify' in selected_player.lower():
            icon = "spotify"
            player_name = "Spotify"
        elif 'plexamp' in selected_player.lower():
            icon = "plex"
            player_name = "Plexamp"
        elif 'vivaldi' in selected_player.lower() or 'browser' in selected_player.lower():
            icon = "web"
            player_name = "Browser"
        else:
            icon = "default"
            
        # Format display text
        if artist and title:
            text = f"{artist} - {title}"
        elif title:
            text = title
        elif artist:
            text = artist
        else:
            text = "Unknown"
            
        # Truncate if too long
        if len(text) > 30:
            text = text[:27] + "..."
            
        # Add play/pause indicator with better Nerd Font icons
        if status == "Playing":
            text = f" {text}"  # Play icon
        elif status == "Paused":
            text = f" {text}"  # Pause icon
        else:
            text = f" {text}"  # Stop icon
            
        return {
            "text": text,
            "class": f"custom-media-{status.lower()}",
            "alt": icon,
            "tooltip": f"[{player_name}] {artist} - {title}\nClick to cycle players | Middle-click to play/pause" if artist and title else f"[{player_name}] {text}\nClick to cycle players | Middle-click to play/pause"
        }
    except subprocess.CalledProcessError:
        return None
    except FileNotFoundError:
        return None

def handle_click(button):
    """Handle mouse clicks"""
    if button == "1":  # Left click - cycle players
        cycle_player()
    elif button == "2":  # Middle click - play/pause
        selected_player = get_selected_player()
        if selected_player:
            subprocess.run(['playerctl', '--player', selected_player, 'play-pause'], 
                         capture_output=True)
    elif button == "3":  # Right click - next track
        selected_player = get_selected_player()
        if selected_player:
            subprocess.run(['playerctl', '--player', selected_player, 'next'], 
                         capture_output=True)

def main():
    # Check if this is a click event
    if len(sys.argv) > 1:
        handle_click(sys.argv[1])
        return
    
    info = get_player_info()
    if info:
        print(json.dumps(info))
    else:
        # No media playing
        players = get_all_players()
        player_list = ", ".join(players) if players else "None"
        print(json.dumps({
            "text": "♪ No Media",
            "class": "custom-media-stopped",
            "alt": "default",
            "tooltip": f"Available players: {player_list}\nClick to cycle players"
        }))

if __name__ == "__main__":
    main()