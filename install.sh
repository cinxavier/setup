#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "starting config"

# -------- DCONF --------
echo "setting dconf..."

[ -f "$REPO_DIR/dconf/interface.ini" ] && \
dconf load /org/gnome/desktop/interface/ < "$REPO_DIR/dconf/interface.ini"

[ -f "$REPO_DIR/dconf/wm.ini" ] && \
dconf load /org/gnome/desktop/wm/preferences/ < "$REPO_DIR/dconf/wm.ini"
echo "interface set."

[ -f "$REPO_DIR/dconf/keybindings.ini" ] && \
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$REPO_DIR/dconf/keybindings.ini"
echo "keybinds set."

echo "reseting terminal..."
dconf reset -f /org/gnome/terminal/

[ -f "$REPO_DIR/dconf/terminal.ini" ] && \
dconf load /org/gnome/terminal/ < "$REPO_DIR/dconf/terminal.ini"
echo "GNOME terminal set."

[ -f "$REPO_DIR/dconf/mouse.ini" ] && \
dconf load /org/gnome/desktop/peripherals/mouse/ < "$REPO_DIR/dconf/mouse.ini"

[ -f "$REPO_DIR/dconf/touchpad.ini" ] && \
dconf load /org/gnome/desktop/peripherals/touchpad/ < "$REPO_DIR/dconf/touchpad.ini"
echo "mouse set."

echo "dconf done."

echo "setting vscode"
# -------- VSCODE --------
VSCODE_DIR="$HOME/.config/Code/User"

if [ -d "$HOME/.config/Code" ]; then
    mkdir -p "$VSCODE_DIR"


    cp "$REPO_DIR/vscode/keybindings.json" "$VSCODE_DIR/" 2>/dev/null || true
    echo "keybinds set."

    cp "$REPO_DIR/vscode/settings.json" "$VSCODE_DIR/" 2>/dev/null || true
    echo "user settings set."
fi

echo "vscode done."
echo "perhaps the machine needs to logout/login"
