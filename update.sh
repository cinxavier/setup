#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "updating configs..."

mkdir -p "$REPO_DIR/dconf"
mkdir -p "$REPO_DIR/vscode"

# -------- DCONF (FILTRADO) --------
echo "Exporting dconf..."

dconf dump /org/gnome/desktop/interface/ > "$REPO_DIR/dconf/interface.ini"
dconf dump /org/gnome/desktop/wm/preferences/ > "$REPO_DIR/dconf/wm.ini"
echo "interface exported."
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$REPO_DIR/dconf/keybindings.ini"
echo "keybinds exported."
dconf dump /org/gnome/desktop/peripherals/mouse/ > "$REPO_DIR/dconf/mouse.ini"
dconf dump /org/gnome/desktop/peripherals/touchpad/ > "$REPO_DIR/dconf/touchpad.ini"
echo "mouse exported."

echo "dconf done."
# -------- VSCODE --------
VSCODE_DIR="$HOME/.config/Code/User"
echo "exporting vscode..."
if [ -d "$VSCODE_DIR" ]; then
    cp "$VSCODE_DIR/keybindings.json" "$REPO_DIR/vscode/" 2>/dev/null || true
    echo "keybinds exported."
    cp "$VSCODE_DIR/settings.json" "$REPO_DIR/vscode/" 2>/dev/null || true
    echo "user settings exported."
fi

# -------- GIT --------
cd "$REPO_DIR"

git add .
git commit --allow-empty -m "update: configs $(date)" || echo "nothing to commit"
git push origin main

echo ""
echo "update done."
#teste update
