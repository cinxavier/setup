#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "starting config..."

# -------- CLI SETUP --------
echo "setting global command 'dot'..."

mkdir -p "$HOME/.local/bin"

if [ ! -f "$HOME/.local/bin/dot" ]; then
    ln -s "$REPO_DIR/bin/dot" "$HOME/.local/bin/dot"
    chmod +x "$REPO_DIR/bin/dot"
    echo "'dot' command set."
fi

COMPLETION_DIR="$HOME/.config/dotfiles"
COMPLETION_FILE="$COMPLETION_DIR/dot-completion.sh"

mkdir -p "$COMPLETION_DIR"

cat > "$COMPLETION_FILE" << 'EOF'
_dot_completion() {
    local cur

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    COMPREPLY=( $(compgen -W "install update upload" -- "$cur") )
}

complete -F _dot_completion dot
EOF

chmod 644 "$COMPLETION_FILE"

if ! grep -q "dot-completion.sh" "$HOME/.bashrc"; then
    echo "source $COMPLETION_FILE" >> "$HOME/.bashrc"
    echo " Autocomplete added to .bashrc"
fi

# -------- DCONF --------
echo "setting dconf..."

[ -f "$REPO_DIR/dconf/interface.ini" ] && \
dconf load /org/gnome/desktop/interface/ < "$REPO_DIR/dconf/interface.ini"

[ -f "$REPO_DIR/dconf/wm.ini" ] && \
dconf load /org/gnome/desktop/wm/preferences/ < "$REPO_DIR/dconf/wm.ini"
echo "interface set."

echo "reseting dock..."

dconf reset /org/gnome/shell/favorite-apps

echo "applaing new dock..."

dconf load /org/gnome/shell/ < "$REPO_DIR/dconf/shell.ini"


# keybinds
# reseting original keybinds to overwrite mine
echo "reseting keybinds..."
dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/
dconf reset -f /org/gnome/desktop/wm/keybindings/
echo "done."

# setting my keybinds
[ -f "$REPO_DIR/dconf/keybindings.ini" ] && \
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$REPO_DIR/dconf/keybindings.ini"
dconf load /org/gnome/desktop/wm/keybindings/ < "$REPO_DIR/dconf/wm-keybindings.ini"
echo "keybinds set."


# terminal reset
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

# ------- FIREFOX --------

echo "setting firefox..."

FIREFOX_DIR="$HOME/snap/firefox/common/.mozilla/firefox"
PROFILE=$(find "$FIREFOX_DIR" -maxdepth 1 -type d -name "*.default" | head -n 1)

if [ -n "$PROFILE" ]; then
    for file in $REPO_DIR/firefox/*; do
        echo "installing $file"
        if [ -f $file ]; then
            cp "$file" "$PROFILE/" 2>/dev/null || true
        elif [ -d $file ]; then
            cp -r "$file" "$PROFILE/" 2>/dev/null || true
        fi
    done
fi

echo "firefox set."

# --------- DEFAULT APPS ---------
mkdir -p "$HOME/.config"

cp "$REPO_DIR/mime/mimeapps.list" "$HOME/.config/" 2>/dev/null || true
echo "default apps done."

# -------- VSCODE --------
echo "setting vscode"

VSCODE_DIR="$HOME/.config/Code/User"

if [ -d "$HOME/.config/Code" ]; then
    mkdir -p "$VSCODE_DIR"


    cp "$REPO_DIR/vscode/keybindings.json" "$VSCODE_DIR/" 2>/dev/null || true
    echo "keybinds set."

    cp "$REPO_DIR/vscode/settings.json" "$VSCODE_DIR/" 2>/dev/null || true
    echo "user settings set."
fi

echo "vscode done."

# -------- PROJECTS --------
PROJECTS_FOLDER="$HOME/projects"

if [ ! -d $PROJECTS_FOLDER ]; then
    mkdir -p "$PROJECTS_FOLDER"
fi
GITHUB_REPO="https://github.com/cinxavier"

REPOS=('exercicios-IP' 'exercicios-IC' 'game-ip' 'cinirriga')
for repo in "${REPOS[@]}"; do
    if [ ! -d "$PROJECTS_FOLDER/$repo" ]; then
        echo -n "clonning $repo..."
        git clone $GITHUB_REPO"/"$repo".git" $PROJECTS_FOLDER"/"$repo
        echo "done."
    fi
done



# garantir PATH
if ! echo "$PATH" | grep -q "$HOME/.config/Code/UserME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo "PATH updated (reload the terminal)"
    echo "install done!"
else
    echo "perhaps the machine needs to reboot"
fi


while true; do
    read -p "Deseja reiniciar agora? (s/n) " sn
    case $sn in
        [Ss]* ) reboot;;
        [Nn]* ) exit; echo "Lembre-se de reiniciar o PC";;
        * ) echo "Apenas 's' ou 'n'";;
    esac
done