#!/usr/bin/env bash
# install_dash_to_dock.sh — Install Dash to Dock using GNOME Extensions app on Fedora

set -euo pipefail

echo "→ Installing GNOME Extensions app and Dash to Dock extension..."
sudo dnf install -y gnome-extensions-app gnome-shell-extension-dash-to-dock

echo "→ Enabling Dash to Dock extension..."
gnome-extensions enable dash-to-dock@micxgx.gmail.com

echo "→ Configuring GNOME window button layout"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

echo "✔ Dash to Dock has been installed and enabled."
echo "   ➤ You can manage it via the GNOME Extensions app."
echo "   ➤ To configure settings, open the Extensions app and click the gear icon next to Dash to Dock."
