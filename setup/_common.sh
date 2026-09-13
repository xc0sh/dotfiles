#!/usr/bin/env bash
# Sourced by the setup/*.sh scripts that reference $repo_path and/or the
# info/warn/error helpers. Normally both are supplied by the caller --
# xc0sh/xcloud-dotfiles-installer sets repo_path as a local variable in its
# run_setup_logic function (visible to whatever it `source`s) and defines
# info/warn/error globally via its own lib/colors.sh before ever reaching
# these scripts. This file makes each script work standalone too, e.g. when
# run directly as the README's manual-install fallback instructs, without
# overriding either when a caller already provided them.

: "${repo_path:=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." &> /dev/null && pwd)}"

if ! declare -f info &> /dev/null; then
    _common_sh_RED='\033[0;31m'
    _common_sh_GREEN='\033[0;32m'
    _common_sh_YELLOW='\033[1;33m'
    _common_sh_NC='\033[0m'
    info()  { echo -e "${_common_sh_GREEN}[INFO]${_common_sh_NC} $1"; }
    warn()  { echo -e "${_common_sh_YELLOW}[WARN]${_common_sh_NC} $1"; }
    error() { echo -e "${_common_sh_RED}[ERROR]${_common_sh_NC} $1"; }
fi
