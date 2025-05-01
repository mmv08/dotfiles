#!/usr/bin/env bash
set -euo pipefail

REPO_FILE=/etc/yum.repos.d/1password.repo
PKG=1password

# Configure repository if not present
if [ ! -f "$REPO_FILE" ]; then
  echo "Importing 1Password GPG key and adding repository..."
  sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
  sudo tee "$REPO_FILE" > /dev/null <<'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF
else
  echo "1Password repository already configured."
fi

# Install package if not installed
if ! rpm -q "$PKG" >/dev/null 2>&1; then
  echo "Installing $PKG..."
  sudo dnf install -y "$PKG"
else
  echo "$PKG is already installed."
fi
