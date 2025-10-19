#!/bin/bash
# Hyprland Keybinds Cheatsheet - Two Column Layout
# Displays all configured keybindings in a readable format

CONFIG="$HOME/.config/hypr/hyprland.conf"

# ANSI color codes
BOLD='\033[1m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

clear

echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                    HYPRLAND KEYBINDS CHEATSHEET                                                                      ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

# Two column layout function
print_two_cols() {
    local left="$1"
    local right="$2"
    echo -e "$(printf "%-110s" "$left")$right"
}

echo -e "${BOLD}${CYAN}🚀 LAUNCHERS & APPS${RESET}                                              ${BOLD}${CYAN}🪟 WINDOW MANAGEMENT${RESET}"
print_two_cols "  ${GREEN}Super Return${RESET}          → Terminal" "  ${GREEN}Super Q${RESET}               → Kill active window"
print_two_cols "  ${GREEN}Alt Space${RESET}             → Rofi launcher" "  ${GREEN}Super V${RESET}               → Toggle floating"
print_two_cols "  ${GREEN}Super E${RESET}               → File manager" "  ${GREEN}Super F${RESET}               → Fullscreen"
print_two_cols "  ${GREEN}Super N${RESET}               → Notification center" "  ${GREEN}Super T${RESET}               → Toggle split direction"
print_two_cols "  ${GREEN}Super C${RESET}               → Clipboard manager" ""
print_two_cols "" "  ${GREEN}Super Arrow Keys${RESET}      → Move focus"
print_two_cols "" "  ${GREEN}Super Shift Arrows${RESET}    → Move window"

echo ""
echo -e "${BOLD}${CYAN}📦 SCRATCHPADS${RESET}                                                       ${BOLD}${CYAN}🖥️  WORKSPACES${RESET}"
print_two_cols "  ${GREEN}Super Space${RESET}           → Terminal" "  ${GREEN}Super 1-9, 0${RESET}          → Switch workspace"
print_two_cols "  ${GREEN}Ctrl Space${RESET}            → Claude AI" "  ${GREEN}Super Shift 1-9, 0${RESET}    → Move to workspace"
print_two_cols "  ${GREEN}Super K${RESET}               → Keybinds" "  ${GREEN}Super S${RESET}               → Toggle special"
print_two_cols "  ${GREEN}Super B${RESET}               → Btop" "  ${GREEN}Super Shift S${RESET}         → Move to special"
print_two_cols "  ${GREEN}Super M${RESET}               → Plexamp" "  ${GREEN}Super P${RESET}               → PiP workspace"
print_two_cols "  ${GREEN}Super =${RESET}               → Calculator" "  ${GREEN}Super A${RESET}               → Mission Control"
print_two_cols "  ${GREEN}Super D${RESET}               → Dolphin" "  ${GREEN}Mouse Btn 277${RESET}         → Mission Control"
print_two_cols "  ${GREEN}Super Y${RESET}               → Yazi" ""
print_two_cols "  ${GREEN}Super X${RESET}               → Plex" ""
print_two_cols "  ${GREEN}Super R${RESET}               → Discord" ""
print_two_cols "  ${GREEN}Super O${RESET}               → Obsidian" ""
print_two_cols "  ${GREEN}Super J${RESET}               → Anki" ""
print_two_cols "  ${GREEN}Super Shift V${RESET}         → Volume" ""

echo ""
echo -e "${BOLD}${CYAN}🎵 MEDIA${RESET}                                                             ${BOLD}${CYAN}📸 SCREENSHOTS & BRIGHTNESS${RESET}"
print_two_cols "  ${GREEN}Media Keys${RESET}            → Next/Prev/Play/Pause" "  ${GREEN}Alt Shift 3/4/5${RESET}      → Full/Region/Menu"
print_two_cols "  ${GREEN}Volume Keys${RESET}           → Up/Down/Mute" "  ${GREEN}Print${RESET}                 → Quick screenshot"
print_two_cols "  ${GREEN}RCtrl Arrows${RESET}          → Advanced media control" "  ${GREEN}Brightness Keys${RESET}      → Up/Down"
print_two_cols "  ${GREEN}RCtrl Up${RESET}              → Cycle player" ""

echo ""
echo -e "${BOLD}${CYAN}🔒 SYSTEM${RESET}                                                            ${BOLD}${CYAN}🖱️  MOUSE & UI${RESET}"
print_two_cols "  ${GREEN}Super L${RESET}               → Lock screen" "  ${GREEN}Super Left Click${RESET}      → Move window"
print_two_cols "  ${GREEN}Super Shift \`${RESET}         → Save session" "  ${GREEN}Super Right Click${RESET}     → Resize window"
print_two_cols "  ${GREEN}Super Ctrl \`${RESET}          → Restore session" "  ${GREEN}Super Scroll${RESET}          → Switch workspace"
print_two_cols "" "  ${GREEN}Super W${RESET}               → Wallpaper gallery"
print_two_cols "" "  ${GREEN}Super \`${RESET}               → Workspace overview"

# Keep it open until user closes
read -n 1 -s -r key
