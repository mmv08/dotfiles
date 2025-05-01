#!/usr/bin/env bash
set -euo pipefail

# Ensure curl is installed
if ! command -v curl >/dev/null; then
  echo "Installing curl..."
  sudo dnf install -y curl
fi

# Setup NVM
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
else
  echo "Updating NVM..."
  git -C "$NVM_DIR" pull --ff-only
fi

# Load NVM
# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"

# Install or update Node.js LTS version
echo "Installing or updating Node.js LTS version..."
nvm install --lts
nvm alias default 'lts/*'

# Verify installation
echo "Node.js version: $(nvm current)"
echo "npm version: $(npm -v)"

