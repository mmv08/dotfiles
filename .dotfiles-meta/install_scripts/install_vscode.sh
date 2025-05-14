#!/usr/bin/env bash
set -euo pipefail

REPO_FILE=/etc/yum.repos.d/vscode.repo
if [ ! -f "$REPO_FILE" ]; then
  echo "Importing VS Code GPG key and adding repository..."
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo tee "$REPO_FILE" > /dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
else
  echo "VS Code repository already configured."
fi

if command -v code >/dev/null; then
  echo "VS Code is already installed."
else
  echo "Installing VS Code..."
  sudo dnf check-update || true
  sudo dnf install -y code
fi
