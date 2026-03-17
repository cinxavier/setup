#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Atualizando configs..."

mkdir -p "$REPO_DIR/dconf"
mkdir -p "$REPO_DIR/vscode"

# -------- DCONF (FILTRADO) --------
echo "Exportando dconf (tema, atalhos, mouse)..."

dconf dump /org/gnome/desktop/interface/ > "$REPO_DIR/dconf/interface.ini"
dconf dump /org/gnome/desktop/wm/preferences/ > "$REPO_DIR/dconf/wm.ini"
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$REPO_DIR/dconf/keybindings.ini"
dconf dump /org/gnome/desktop/peripherals/mouse/ > "$REPO_DIR/dconf/mouse.ini"
dconf dump /org/gnome/desktop/peripherals/touchpad/ > "$REPO_DIR/dconf/touchpad.ini"

# -------- VSCODE --------
VSCODE_DIR="$HOME/.config/Code/User"

if [ -d "$VSCODE_DIR" ]; then
    cp "$VSCODE_DIR/keybindings.json" "$REPO_DIR/vscode/" 2>/dev/null || true
    cp "$VSCODE_DIR/settings.json" "$REPO_DIR/vscode/" 2>/dev/null || true
fi

# -------- GIT --------
cd "$REPO_DIR"

git add .
git commit -m "update: configs $(date)" || echo "Nada para commit"
git push origin main

echo "✔ Atualização concluída!"
