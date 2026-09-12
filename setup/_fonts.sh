#!/usr/bin/env bash
# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

# shellcheck disable=SC2154 # repo_path is exported by the external installer (unforked, see README Known Limitations), not set anywhere in this repo
sudo cp -rf "$repo_path"/setup/fonts/FiraCode /usr/share/fonts
sudo cp -rf "$repo_path"/setup/fonts/Fira_Sans /usr/share/fonts
sudo cp -rf "$repo_path"/setup/fonts/Material-Icons /usr/share/fonts
