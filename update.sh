#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "updating configs..."

mkdir -p "$REPO_DIR/dconf"
mkdir -p "$REPO_DIR/vscode"

# -------- DCONF --------
echo -n "Exporting dconf..."

dconf dump /org/gnome/desktop/interface/ > "$REPO_DIR/dconf/interface.ini"
dconf dump /org/gnome/desktop/wm/preferences/ > "$REPO_DIR/dconf/wm.ini"
echo "interface exported."


# keybinds
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$REPO_DIR/dconf/keybindings.ini"
dconf dump /org/gnome/desktop/wm/keybindings/ > "$REPO_DIR/dconf/wm-keybindings.ini"
echo "keybinds exported."

# mouse
dconf dump /org/gnome/desktop/peripherals/mouse/ > "$REPO_DIR/dconf/mouse.ini"
dconf dump /org/gnome/desktop/peripherals/touchpad/ > "$REPO_DIR/dconf/touchpad.ini"
echo "mouse exported."

# terminal
dconf dump /org/gnome/terminal/ > "$REPO_DIR/dconf/terminal.ini"
dconf dump /org/gnome/shell/ > "$REPO_DIR/dconf/shell.ini"
echo "GNOME terminal exported."

echo "done."

# ------------- firefox -------------
echo -n "Exporting Firefox..."

FIREFOX_DIR="$HOME/.mozilla/firefox"
mkdir -p "$REPO_DIR/firefox"

PROFILE=$(find "$FIREFOX_DIR" -maxdepth 1 -type d -name "*.default-release" | head -n 1)

if [ -n "$PROFILE" ]; then
    # config segura
    cp "$PROFILE/user.js" "$REPO_DIR/firefox/" 2>/dev/null || true

    # -------- LANGUAGE PACK --------
    EXT_DIR="$PROFILE/extensions"

    if [ -d "$EXT_DIR" ]; then
        LANGPACK=$(find "$EXT_DIR" -name "langpack-*.xpi" | head -n 1)

        if [ -n "$LANGPACK" ]; then
            cp "$LANGPACK" "$REPO_DIR/firefox/"
            echo "Language pack copied"
        else
            echo "No language pack found"
        fi
    fi
fi
echo "done."


# --------- DEFAULT APPS ----------

mkdir -p "$REPO_DIR/mime"

cp "$HOME/.config/mimeapps.list" "$REPO_DIR/mime/" 2>/dev/null || true




# -------- VSCODE --------
VSCODE_DIR="$HOME/.config/Code/User"
echo -n "Exporting vscode..."
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

echo "done"

echo "update done."
#teste update
