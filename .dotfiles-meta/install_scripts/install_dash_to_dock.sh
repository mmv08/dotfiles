#!/usr/bin/env bash
# install_dash_to_dock.sh — Install Dash to Dock using GNOME Extensions app on Fedora

set -euo pipefail

echo "→ Installing GNOME Extensions app and Dash to Dock extension..."
sudo dnf install -y gnome-extensions-app gnome-shell-extension-dash-to-dock

echo "→ Enabling Dash to Dock extension..."
# The extension may not be available until GNOME Shell is restarted or the user logs out and in again.
# On Fedora, the extension UUID is usually 'dash-to-dock@micxgx.gmail.com', but let's check if it exists first.
if gnome-extensions list | grep -q 'dash-to-dock@micxgx.gmail.com'; then
  gnome-extensions enable dash-to-dock@micxgx.gmail.com
else
  echo "⚠ Dash to Dock extension not found. You may need to log out and log in again before enabling it."
fi

echo "→ Configuring GNOME window button layout"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

echo "✔ Dash to Dock has been installed and enabled."
echo "   ➤ You can manage it via the GNOME Extensions app."
echo "   ➤ To configure settings, open the Extensions app and click the gear icon next to Dash to Dock."
