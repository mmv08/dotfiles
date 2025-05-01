#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
sudo dnf update -y

# Install Zsh
sudo dnf install -y zsh

# Install Oh My Zsh if not already installed
if [ -d "${HOME}/.oh-my-zsh" ]; then
  echo "→ Oh My Zsh already installed, skipping installation"
else
  echo "→ Installing Oh My Zsh"
  export KEEP_ZSHRC=yes
  export RUNZSH=no
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
