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
      currentBranch=$(git -C "$folder" branch --show-current)
      git -C "$folder" pull origin "$currentBranch" --quiet
    fi
    echo "done."
  done
fi

echo "Deseja instalar as atualizações? (S/n) "
while true; do
    read -s -n 1 sn
    if [[ -z $sn || $sn = "s" || $sn = "S" ]]; then
        $HOME/setup/install.sh
        break
    elif [[ $sn = "n" || $sn = "N" ]]; then
        exit
        break
    else
        echo "Apenas 'sS' ou 'nN'"
    fi
done
