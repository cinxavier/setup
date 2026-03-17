#!/bin/bash

echo "Aplicando configurações do GNOME..."
dconf load /org/gnome/ < dconf-settings.ini

echo "Configurando bash..."
cp bashrc ~/.bashrc

echo "Configurando VS Code..."
cp vscode-settings.json ~/.config/Code/User/settings.json
cp keybindings.json ~/.config/Code/User/keybindings.json

echo "Instalando extensões do VS Code..."
cat extensions.txt | xargs -L 1 code --install-extension

echo "Aplicando configuração do mouse..."
bash mouse.sh

echo "Finalizado!
