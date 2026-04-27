#!/bin/bash
set -e

projects_dir="$HOME/projects"

echo "updating projects"

for folder in "$projects_dir"/*; do
  echo -n "updating "$folder"..."
  echo "done."
done