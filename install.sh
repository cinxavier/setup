#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Aplicando configurações (modo usuário)..."

# -------- DCONF --------
echo "Aplicando dconf..."

[ -f "$REPO_DIR/dconf/interface.ini" ] && \
dconf load /org/gnome/desktop/interface/ < "$REPO_DIR/dconf/interface.ini"

[ -f "$REPO_DIR/dconf/wm.ini" ] && \
dconf load /org/gnome/desktop/wm/preferences/ < "$REPO_DIR/dconf/wm.ini"

[ -f "$REPO_DIR/dconf/keybindings.ini" ] && \
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$REPO_DIR/dconf/keybindings.ini"

[ -f "$REPO_DIR/dconf/mouse.ini" ] && \
dconf load /org/gnome/desktop/peripherals/mouse/ < "$REPO_DIR/dconf/mouse.ini"

[ -f "$REPO_DIR/dconf/touchpad.ini" ] && \
dconf load /org/gnome/desktop/peripherals/touchpad/ < "$REPO_DIR/dconf/touchpad.ini"

# -------- VSCODE --------
VSCODE_DIR="$HOME/.config/Code/User"

if [ -d "$HOME/.config/Code" ]; then
    echo "Aplicando VS Code..."
    mkdir -p "$VSCODE_DIR"

    cp "$REPO_DIR/vscode/keybindings.json" "$VSCODE_DIR/" 2>/dev/null || true
    cp "$REPO_DIR/vscode/settings.json" "$VSCODE_DIR/" 2>/dev/null || true
fi

echo "✔ Tudo aplicado (sem sudo!)"
echo "⚠️ Se algo não aplicar, faça logout/login"
