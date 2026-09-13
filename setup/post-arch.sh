#!/usr/bin/env bash

# shellcheck source=setup/_common.sh
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/_common.sh"

# --------------------------------------------------------------
# Oh My Posh
# --------------------------------------------------------------
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

# --------------------------------------------------------------
# xCloud Settings App
# --------------------------------------------------------------

bash <(curl -s https://raw.githubusercontent.com/xc0sh/xcloud-dotfiles-settings/main/setup.sh)

# --------------------------------------------------------------
# Quickshell Overview
# --------------------------------------------------------------

bash <(curl -s https://raw.githubusercontent.com/xc0sh/xcloud-quickshell-overview/main/install.sh)

# --------------------------------------------------------------
# Pipx
# --------------------------------------------------------------

echo ":: Installing packages with pipx"
pipx install pywalfox
# pipx symlinks into ~/.local/bin, which isn't guaranteed to already be on
# PATH in the shell this script is sourced from -- ensure it's there so the
# binary just installed above can actually be found on the next line.
export PATH="$HOME/.local/bin:$PATH"
pywalfox install

# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

source "$repo_path"/setup/_cursors.sh

# --------------------------------------------------------------
# Fonts
# --------------------------------------------------------------

source "$repo_path"/setup/_fonts.sh

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

source "$repo_path"/setup/_icons.sh

# --------------------------------------------------------------
# Create XDG Directories
# --------------------------------------------------------------

xdg-user-dirs-update

