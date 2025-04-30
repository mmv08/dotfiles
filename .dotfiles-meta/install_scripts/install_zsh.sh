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
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Change the default shell to Zsh using a shell builtin
ZSH_PATH=$(command -v zsh || true)
if [[ -n "$ZSH_PATH" ]]; then
  chsh -s "$ZSH_PATH" || echo "Warning: failed to change shell to $ZSH_PATH"
else
  echo "Warning: zsh not found in PATH; skipping default shell change."
fi

echo "Installation complete. Please log out and log back in to start using Zsh with Oh My Zsh."