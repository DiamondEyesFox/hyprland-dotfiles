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
print_two_cols "" "  ${GREEN}Super Arrow Keys${RESET}      → Move focus"
print_two_cols "" "  ${GREEN}Super Shift Arrows${RESET}    → Move window"

echo ""
echo -e "${BOLD}${CYAN}📦 SCRATCHPADS (Instant Apps)${RESET}                                    ${BOLD}${CYAN}🖥️  WORKSPACES${RESET}"
print_two_cols "  ${GREEN}Super Space${RESET}           → Quick terminal" "  ${GREEN}Super 1-9, 0${RESET}          → Switch to workspace"
print_two_cols "  ${GREEN}Ctrl Space${RESET}            → Claude Code AI" "  ${GREEN}Super Shift 1-9, 0${RESET}    → Move window to workspace"
print_two_cols "  ${GREEN}Super K${RESET}               → Keybinds cheatsheet" "  ${GREEN}Super S${RESET}               → Toggle special workspace"
print_two_cols "  ${GREEN}Super B${RESET}               → System monitor (btop)" "  ${GREEN}Super P${RESET}               → Toggle PiP workspace"
print_two_cols "  ${GREEN}Super M${RESET}               → Music player (Plexamp)" "  ${GREEN}Super Tab${RESET}             → Workspace overview"
print_two_cols "  ${GREEN}Super Shift V${RESET}         → Volume control" "  ${GREEN}Super A${RESET}               → Mission Control (Expose)"
print_two_cols "" "  ${GREEN}Mouse Btn 277${RESET}         → Mission Control"

echo ""
echo -e "${BOLD}${CYAN}🎵 MEDIA CONTROLS${RESET}                                                ${BOLD}${CYAN}📸 SCREENSHOTS${RESET}"
print_two_cols "  ${GREEN}XF86AudioNext${RESET}         → Next track" "  ${GREEN}Alt Shift 3${RESET}           → Full screenshot"
print_two_cols "  ${GREEN}XF86AudioPrev${RESET}         → Previous track" "  ${GREEN}Alt Shift 4${RESET}           → Region screenshot"
print_two_cols "  ${GREEN}XF86AudioPlay${RESET}         → Play/Pause" "  ${GREEN}Alt Shift 5${RESET}           → Screenshot menu"
print_two_cols "  ${GREEN}XF86AudioRaise${RESET}        → Volume up 5%" "  ${GREEN}Print${RESET}                 → Quick screenshot"
print_two_cols "  ${GREEN}XF86AudioLower${RESET}        → Volume down 5%" ""
print_two_cols "  ${GREEN}XF86AudioMute${RESET}         → Toggle mute" ""

echo ""
echo -e "${BOLD}${CYAN}🔒 SYSTEM & SESSION${RESET}                                              ${BOLD}${CYAN}🖼️  WALLPAPER & UI${RESET}"
print_two_cols "  ${GREEN}Super L${RESET}               → Lock screen" "  ${GREEN}Super W${RESET}               → Wallpaper gallery"
print_two_cols "  ${GREEN}Super Shift \`${RESET}         → Save session" "  ${GREEN}Super \`${RESET}               → Workspace overview"
print_two_cols "  ${GREEN}Super Ctrl \`${RESET}          → Restore session" ""

echo ""
echo -e "${BOLD}${CYAN}🖱️  MOUSE BINDINGS${RESET}"
print_two_cols "  ${GREEN}Super Left Click${RESET}      → Move window" "  ${GREEN}Super Scroll Up/Down${RESET}  → Switch workspace"
print_two_cols "  ${GREEN}Super Right Click${RESET}     → Resize window" ""

echo ""
echo -e "${BOLD}${YELLOW}╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${YELLOW}║                                                        Press 'q' to close this cheatsheet                                                            ║${RESET}"
echo -e "${BOLD}${YELLOW}╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝${RESET}"

# Keep it open until user presses q
read -n 1 -s -r key
