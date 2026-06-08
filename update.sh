#!/bin/bash
set -e

git -C "$HOME/setup" pull

projects_dir="$HOME/projects"

if [ ! -d "$projects_dir" ]; then
  echo "projects directory does not exists. Run 'dot install' to create it." 
else
  echo "updating projects"

  for folder in "$projects_dir"/*; do
    echo -n "updating $(basename "$folder")..."
    if [ -d "$folder"/.git/ ]; then
      git -C "$folder" pull origin main --quiet
    fi
    echo "done."
  done
fi

while true; do
    read -p "Deseja instalar as atualizações? (s/n) " sn
    case $sn in
        [Ss]* ) $HOME/setup/install.sh; break;;
        [Nn]* ) exit;;
        * ) echo "Apenas 's' ou 'n'";;
    esac
done
