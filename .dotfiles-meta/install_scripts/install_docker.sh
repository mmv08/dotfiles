#!/usr/bin/env bash
# install_docker.sh — Fedora Docker Engine + Compose v2 installer (official upstream)

set -euo pipefail

###############################################################################
# 1. Install dependencies and add Docker CE repo
###############################################################################
echo "→ Installing dnf plugins and adding Docker CE repo …"
sudo dnf install -y dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

###############################################################################
# 2. Install Docker Engine and Compose plugin
###############################################################################
echo "→ Installing Docker CE and Compose plugin …"
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

###############################################################################
# 3. Enable and start the Docker daemon
###############################################################################
echo "→ Enabling and starting docker.service …"
if [ "$(ps -p 1 -o comm=)" = "systemd" ]; then
  sudo systemctl enable --now docker
else
  echo "Non-systemd environment detected; skipping daemon start"
fi

###############################################################################
# 4. Add current user to docker group (if not already a member)
###############################################################################
echo "→ Adding user '$USER' to docker group …"
# Create docker group if it doesn't exist
if ! getent group docker > /dev/null; then
  sudo groupadd docker
fi

sudo usermod -aG docker "$USER"

echo
echo "✔ Docker and Compose installed."
echo "➡️ You must log out and back in for group changes to take effect."
echo "   Or run: newgrp docker"
echo
docker --version || echo "(Docker not yet usable in this shell session)"
docker compose version || echo "(Compose not yet usable in this shell session)"
