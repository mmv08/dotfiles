#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
echo "Updating system packages..."
sudo dnf upgrade --refresh -y

# Download and run the rustup installation script
echo "Installing Rust using rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Source the environment to update current shell session
echo "Configuring environment..."
source "$HOME/.cargo/env"

# Verify Rust installation
echo "Verifying Rust installation..."
rustc --version
cargo --version

echo "Rust installation completed successfully!"
