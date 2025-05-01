#!/usr/bin/env bash
set -euo pipefail

# Install Zsh if not present
if command -v zsh >/dev/null; then
  echo "Zsh is already installed."
else
  echo "Installing Zsh..."
  sudo dnf install -y zsh
fi

# Install Oh My Zsh if not already installed
if [ -d "${HOME}/.oh-my-zsh" ]; then
  echo "Oh My Zsh already installed."
else
  echo "Installing Oh My Zsh..."
  export KEEP_ZSHRC=yes RUNZSH=no
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
