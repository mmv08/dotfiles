#!/usr/bin/env bash
set -euo pipefail

install_flatpak() {
  if ! command -v flatpak &> /dev/null; then
    echo "Installing Flatpak..."
    sudo dnf install -y flatpak
  else
    echo "Flatpak is already installed."
  fi
}

enable_flathub() {
  if ! flatpak remotes | grep -q '^flathub'; then
    echo "Adding Flathub remote..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  else
    echo "Flathub remote already enabled."
  fi
}

install_telegram_flatpak() {
  if flatpak list --app | grep -q org.telegram.desktop; then
    echo "Telegram Desktop Flatpak is already installed; updating..."
    flatpak update -y org.telegram.desktop
  else
    echo "Installing Telegram Desktop via Flatpak..."
    flatpak install -y flathub org.telegram.desktop
  fi
}

# Run the steps
install_flatpak            # Ensure flatpak is present
enable_flathub             # Ensure Flathub is added :contentReference[oaicite:0]{index=0}
install_telegram_flatpak   # Install or update Telegram :contentReference[oaicite:1]{index=1}

echo "Done! You can launch Telegram with: flatpak run org.telegram.desktop"
