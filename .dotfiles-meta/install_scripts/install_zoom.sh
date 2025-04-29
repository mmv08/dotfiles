#!/usr/bin/env bash
set -euo pipefail

install_zoom_rpm() {
  if command -v zoom &> /dev/null; then
    echo "Zoom is already installed."
    return
  fi

  echo "Importing Zoom GPG public key..."
  wget -qO /tmp/zoom_pubkey.pub https://zoom.us/linux/download/pubkey?version=6-3-10
  sudo rpm --import /tmp/zoom_pubkey.pub

  echo "Downloading Zoom RPM..."
  wget -qO /tmp/zoom_x86_64.rpm https://zoom.us/client/latest/zoom_x86_64.rpm

  echo "Installing Zoom..."
  sudo dnf install -y /tmp/zoom_x86_64.rpm
}

install_zoom_rpm
