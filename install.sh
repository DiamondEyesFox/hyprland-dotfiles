#!/bin/bash
# DiamondEyesFox Hyprland Dotfiles Installer

set -e

echo "╔═══════════════════════════════════════════════════════╗"
echo "║  DiamondEyesFox's Hyprland Dotfiles Installer        ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Backup existing configs
echo -e "${YELLOW}Creating backups of existing configs...${NC}"
BACKUP_DIR=~/.config-backup-$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

for dir in hypr waybar kitty rofi swaync matugen; do
    if [ -d ~/.config/$dir ]; then
        echo "  Backing up $dir..."
        cp -r ~/.config/$dir "$BACKUP_DIR/"
    fi
done

echo -e "${GREEN}✓ Backups saved to: $BACKUP_DIR${NC}"
echo ""

# Install configs
echo -e "${YELLOW}Installing dotfiles...${NC}"
for dir in hypr waybar kitty rofi swaync matugen; do
    echo "  Installing $dir..."
    cp -r $dir ~/.config/
done

# Install wallpaper
echo -e "${YELLOW}Installing wallpaper...${NC}"
mkdir -p ~/Pictures/Wallpapers
cp wallpapers/wallpaper.jpg ~/Pictures/Wallpapers/current.jpg
echo -e "${GREEN}✓ Wallpaper installed${NC}"
echo ""

# Enable services
echo -e "${YELLOW}Enabling services...${NC}"
systemctl --user enable swaync
systemctl --user start swaync
echo -e "${GREEN}✓ Services enabled${NC}"
echo ""

# Generate initial colors
if command -v matugen >/dev/null 2>&1; then
    echo -e "${YELLOW}Generating initial color scheme...${NC}"
    matugen image ~/Pictures/Wallpapers/current.jpg
    echo -e "${GREEN}✓ Colors generated${NC}"
else
    echo -e "${RED}⚠ Matugen not found. Install it to enable dynamic theming.${NC}"
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete!                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Reload Hyprland (Super + Shift + R or restart)"
echo "  2. Press Super + K to see all keybindings"
echo "  3. Enjoy your new setup!"
echo ""
echo "Your old configs are backed up in: $BACKUP_DIR"
