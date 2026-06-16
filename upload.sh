#!/bin/bash
set -e

git config --global credential.helper 'cache --timeout=3600'

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "------ Remote Profile ------ updating configs..."

mkdir -p "$REPO_DIR/dconf"
mkdir -p "$REPO_DIR/vscode"

# -------- DCONF --------
echo "------ Remote Profile ------ Exporting dconf..."

dconf dump /org/gnome/desktop/interface/ > "$REPO_DIR/dconf/interface.ini"
dconf dump /org/gnome/desktop/wm/preferences/ > "$REPO_DIR/dconf/wm.ini"
echo "------ Remote Profile ------ interface exported."


# keybinds
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$REPO_DIR/dconf/keybindings.ini"
dconf dump /org/gnome/desktop/wm/keybindings/ > "$REPO_DIR/dconf/wm-keybindings.ini"
echo "------ Remote Profile ------ keybinds exported."

# mouse
dconf dump /org/gnome/desktop/peripherals/mouse/ > "$REPO_DIR/dconf/mouse.ini"
dconf dump /org/gnome/desktop/peripherals/touchpad/ > "$REPO_DIR/dconf/touchpad.ini"
echo "------ Remote Profile ------ mouse exported."

# terminal
dconf dump /org/gnome/terminal/ > "$REPO_DIR/dconf/terminal.ini"
dconf dump /org/gnome/shell/ > "$REPO_DIR/dconf/shell.ini"
echo "------ Remote Profile ------ GNOME terminal exported."

dconf dump /org/gnome/shell/ > "$REPO_DIR/dconf/shell.ini"
echo "------ Remote Profile ------ dock exported."

echo "------ Remote Profile ------ done."

# ------------- FIREFOX -------------
echo "------ Remote Profile ------ Exporting Firefox"

FIREFOX_DIR="$HOME/snap/firefox/common/.mozilla/firefox"
mkdir -p "$REPO_DIR/firefox"

PROFILE=$(find "$FIREFOX_DIR" -maxdepth 1 -type d -name "*.default" | head -n 1)

EXT_REPO="$REPO_DIR/firefox/extensions"
mkdir -p "$EXT_REPO"

if [ -n "$PROFILE" ]; then
    # -------- LANGUAGE PACK --------
    EXT_DIR="$PROFILE/extensions"
    FILES_LIST=("user.js")
    
    for file in "${FILES_LIST[@]}"; do
        cp "$PROFILE/$file" "$REPO_DIR/firefox/" 2>/dev/null || true
    done

    find "$EXT_DIR" -name "*dictionaries*.xpi" -o -name "*langpack*.xpi" -exec cp {} "$REPO_DIR/firefox/" \; 2>/dev/null || true

    if [ -d "$EXT_DIR" ]; then
        rm -f $EXT_REPO/*.xpi
        cp $EXT_DIR/* $EXT_REPO/
    fi
fi
echo "------ Remote Profile ------ done."


# --------- DEFAULT APPS ----------

mkdir -p "$REPO_DIR/mime"

cp "$HOME/.config/mimeapps.list" "$REPO_DIR/mime/" 2>/dev/null || true




# -------- VSCODE --------
VSCODE_DIR="$HOME/.config/Code/User"
echo "------ Remote Profile ------ Exporting vscode"
if [ -d "$VSCODE_DIR" ]; then
    cp "$VSCODE_DIR/keybindings.json" "$REPO_DIR/vscode/" 2>/dev/null || true
    echo "------ Remote Profile ------ keybinds exported."
    cp "$VSCODE_DIR/settings.json" "$REPO_DIR/vscode/" 2>/dev/null || true
    echo "------ Remote Profile ------ user settings exported."
fi

# -------- GIT --------
cd "$REPO_DIR"

echo "------ Remote Profile ------ committing changes..."

PATHS=("." "$HOME/projects/exercicios-IP" "$HOME/projects/exercicios-IC" "$HOME/projects/projeto-final-ic")
for i in ${PATHS[@]} 
do
    echo "------ Remote Profile ------ $i..."
    if [ -d $i ]; then
        cd $i
        git add .
        git commit -m "update: configs $(date)" --quiet || echo "------ Remote Profile ------ nothing to commit"
        git push origin main
        echo "------ Remote Profile ------ done with $i."
    fi
done

echo "------ Remote Profile ------ done"

echo "------ Remote Profile ------ update done."