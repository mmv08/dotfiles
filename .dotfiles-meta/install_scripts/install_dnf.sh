#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PKG_FILE="$SCRIPT_DIR/dnf-packages.txt"

if [ ! -f "$PKG_FILE" ]; then
    echo "Package list file not found: $PKG_FILE" >&2
    exit 1
fi

# Read non-empty, non-comment lines
mapfile -t packages < <(grep -Ev '^\s*($|#)' "$PKG_FILE")

if [ ${#packages[@]} -eq 0 ]; then
    echo "No DNF packages to install."
    exit 0
fi

echo "Installing DNF packages: ${packages[*]}"
# Install development tool groups
sudo dnf group install -y c-development development-tools

sudo dnf install -y "${packages[@]}"
