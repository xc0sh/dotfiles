#!/usr/bin/env bash

# shellcheck source=setup/_common.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/_common.sh"
# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

sudo cp -rf "$repo_path"/setup/fonts/FiraCode /usr/share/fonts
sudo cp -rf "$repo_path"/setup/fonts/Fira_Sans /usr/share/fonts
sudo cp -rf "$repo_path"/setup/fonts/Material-Icons /usr/share/fonts
