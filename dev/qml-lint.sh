#!/usr/bin/env bash

# Local equivalent of the qml-lint CI job (.github/workflows/lint.yml) -
# lints every .qml file under dotfiles/quickshell/.config/quickshell.
# See that job for the full rationale; kept in sync with it by hand since
# CI can't invoke a local script directly.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_ROOT=$( cd -- "$SCRIPT_DIR/.." &> /dev/null && pwd )
QUICKSHELL_DIR="$REPO_ROOT/dotfiles/quickshell/.config/quickshell"

# shellcheck source=/dev/null
source "$REPO_ROOT/setup/_common.sh"

if [[ ! -d "$QUICKSHELL_DIR" ]]; then
    error "Quickshell config dir not found at $QUICKSHELL_DIR"
    exit 1
fi

# On Arch, a bare `qmllint` on PATH is qt5-declarative's linter (version
# 1.0) - it exits silently/255 on any Quickshell file and can't resolve
# Quickshell's own QML module system at all. qt6-declarative's copy (a
# quickshell dependency) is the one that actually understands this repo's
# QML. Never trust a bare `qmllint` here without checking its version.
QMLLINT=""
for candidate in qmllint6 /usr/lib/qt6/bin/qmllint qmllint; do
    if command -v "$candidate" &> /dev/null; then
        ver=$("$candidate" --version 2>/dev/null)
        if [[ "$ver" == *" 6."* ]]; then
            QMLLINT=$(command -v "$candidate")
            break
        fi
    fi
done
if [[ -z "$QMLLINT" ]]; then
    error "Could not find a Qt6 qmllint (checked qmllint6, /usr/lib/qt6/bin/qmllint, qmllint). Is quickshell/qt6-declarative installed?"
    exit 1
fi
info "Using $QMLLINT ($("$QMLLINT" --version))"

# Quickshell resolves its own "qs.<Dir>" root-relative import alias at
# runtime; qmllint has no idea about it on its own. A directory literally
# named "qs" on the import path, symlinked to this repo's quickshell
# config root, makes "import qs.CustomTheme" etc. resolve the way
# Quickshell itself would.
IMPORT_ROOT=$(mktemp -d)
trap 'rm -rf "$IMPORT_ROOT"' EXIT
ln -s "$QUICKSHELL_DIR" "$IMPORT_ROOT/qs"

# Only --unresolved-type is promoted to error for now: it alone catches
# the historical "lowercase-first-letter component name" bug class
# (verified against the real commit that shipped it broken). --import
# stays at its default (warning) level - several files import their own
# sibling directory as "qs.<SameDir>" without that directory having its
# own qmldir, a real pre-existing gap but a separate, wider cleanup than
# this check is scoped to gate on.
status=0
count=0
while IFS= read -r -d '' f; do
    count=$((count + 1))
    if ! "$QMLLINT" -I "$IMPORT_ROOT" --unresolved-type error "$f"; then
        error "qmllint failed: ${f#"$REPO_ROOT"/}"
        status=1
    fi
done < <(find "$QUICKSHELL_DIR" -name '*.qml' -print0)

if [[ $status -eq 0 ]]; then
    info "All $count QML files passed."
else
    error "One or more QML files failed linting."
fi
exit $status
