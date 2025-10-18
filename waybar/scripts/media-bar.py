#!/usr/bin/env python3
"""
Media progress bar generator for waybar
Creates a visual progress indicator that spans the width of the screen
"""
import subprocess
import json
import sys

def get_media_status():
    """Get current media playback status"""
    try:
        # Get first available player
        players_result = subprocess.run(['playerctl', '--list-all'],
                                       capture_output=True, text=True)
        if players_result.returncode != 0 or not players_result.stdout.strip():
            return None

        player = players_result.stdout.strip().split('\n')[0]

        # Get status
        status_result = subprocess.run(['playerctl', '--player', player, 'status'],
                                      capture_output=True, text=True)
        status = status_result.stdout.strip()

        if status not in ['Playing', 'Paused']:
            return None

        # Get position
        pos_result = subprocess.run(['playerctl', '--player', player, 'position'],
                                   capture_output=True, text=True)
        position = float(pos_result.stdout.strip()) if pos_result.returncode == 0 else 0

        # Get length
        length_result = subprocess.run(['playerctl', '--player', player, 'metadata', 'mpris:length'],
                                      capture_output=True, text=True)
        length_us = int(length_result.stdout.strip()) if length_result.returncode == 0 else 0
        length = length_us / 1000000

        if length == 0:
            return None

        percentage = (position / length) * 100

        return {
            'percentage': percentage,
            'status': status
        }
    except:
        return None

def generate_bar(percentage, width=100, status='Playing'):
    """Generate a visual progress bar"""
    filled = int((percentage / 100) * width)
    empty = width - filled

    # Use block characters for smooth progress
    bar = '█' * filled + '░' * empty

    return bar

def main():
    status = get_media_status()

    if status:
        bar = generate_bar(status['percentage'], width=200)
        class_name = 'playing' if status['status'] == 'Playing' else 'paused'

        print(json.dumps({
            'text': bar,
            'class': f'media-bar-{class_name}',
            'percentage': status['percentage']
        }))
    else:
        # No media, show empty bar
        print(json.dumps({
            'text': '',
            'class': 'media-bar-hidden',
            'percentage': 0
        }))

if __name__ == '__main__':
    main()
