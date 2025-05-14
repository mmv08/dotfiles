#!/usr/bin/env bash
set -euo pipefail

# Install or update rustup and the Rust toolchain
echo "Checking for rustup..."
if command -v rustup >/dev/null; then
  echo "Updating Rust toolchain..."
  rustup update
else
  echo "Installing rustup and Rust toolchain..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Source environment if available
echo "Configuring Cargo environment..."
if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
fi

echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"
echo "Rust installation or update completed successfully!"
