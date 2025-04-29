#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SCRIPTS_DIR="$SCRIPT_DIR/install_scripts"

echo "Starting bootstrap installation..."

# Run each install script in install_scripts directory
for script in "$SCRIPTS_DIR"/*.sh; do
    [ -f "$script" ] || continue
    script_name="$(basename "$script")"
    echo "Running $script_name..."
    if [ -x "$script" ]; then
        "$script"
    else
        bash "$script"
    fi
done

echo "Bootstrap installation completed."