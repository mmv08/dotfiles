#!/usr/bin/env bash
set -euo pipefail

# Script to install ProtonVPN app on Fedora

# Download ProtonVPN repository configuration package
TEMP_RPM="/tmp/protonvpn-stable-release.rpm"
wget -O "$TEMP_RPM" "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm"

# Install the ProtonVPN repository and refresh metadata
sudo dnf install -y "$TEMP_RPM"
sudo dnf update --refresh

# Install the ProtonVPN GNOME desktop app
sudo dnf install -y proton-vpn-gnome-desktop

# Optional: install System Tray extensions for GNOME
sudo dnf install -y libappindicator-gtk3 gnome-shell-extension-appindicator gnome-extensions-app

echo "\nProtonVPN installation complete."
echo "Please restart your system and enable 'AppIndicator and KStatusNotifierItem Support' in the Extensions app before launching ProtonVPN."

