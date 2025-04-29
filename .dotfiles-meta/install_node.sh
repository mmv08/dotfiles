#!/bin/bash

# Exit on any error
set -e

# Install curl if not already installed
sudo dnf install -y curl

# Download and install NVM
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Load NVM into current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install the latest LTS version of Node.js
nvm install --lts

# Set the installed LTS version as default
nvm alias default 'lts/*'

# Verify installation
node -v
npm -v

