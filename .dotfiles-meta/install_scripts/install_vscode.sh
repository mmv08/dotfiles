#!/bin/bash

# Import Microsoft's GPG key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add the VS Code repository
sudo sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Update package cache
sudo dnf check-update

# Install VS Code
sudo dnf install -y code
