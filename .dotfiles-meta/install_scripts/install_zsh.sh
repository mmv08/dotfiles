#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
sudo dnf update -y

# Install Zsh
sudo dnf install -y zsh

# Install curl and git if not already installed
sudo dnf install -y curl git

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Change the default shell to Zsh
chsh -s $(which zsh)

echo "Installation complete. Please log out and log back in to start using Zsh with Oh My Zsh."