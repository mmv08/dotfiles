#!/usr/bin/env bash
# install_jetbrains_toolbox.sh — Install JetBrains Toolbox App on Fedora

set -euo pipefail

echo "→ Installing required packages..."
sudo dnf install -y fuse fuse-libs jq curl

echo "→ Fetching latest JetBrains Toolbox release URL..."
TOOLBOX_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' \
  | jq -r '.TBA[0].downloads.linux.link')

echo "→ Downloading Toolbox App from $TOOLBOX_URL..."
curl -L "$TOOLBOX_URL" -o /tmp/jetbrains-toolbox.tar.gz

echo "→ Extracting Toolbox App..."
mkdir -p ~/.local/share/JetBrains/Toolbox
tar -xzf /tmp/jetbrains-toolbox.tar.gz -C ~/.local/share/JetBrains/Toolbox --strip-components=1

echo "→ Creating symbolic link..."
mkdir -p ~/.local/bin
ln -sf ~/.local/share/JetBrains/Toolbox/jetbrains-toolbox ~/.local/bin/jetbrains-toolbox

echo "→ Creating desktop entry..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/jetbrains-toolbox.desktop <<EOF
[Desktop Entry]
Name=JetBrains Toolbox
Comment=Manage your JetBrains tools
Exec=$HOME/.local/share/JetBrains/Toolbox/jetbrains-toolbox
Icon=$HOME/.local/share/JetBrains/Toolbox/toolbox.svg
Terminal=false
Type=Application
Categories=Development;IDE;
EOF

echo "✔ JetBrains Toolbox installed successfully."
echo "➡️ Run it with: jetbrains-toolbox"

