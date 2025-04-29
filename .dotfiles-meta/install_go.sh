#!/usr/bin/env bash
#
# install-go.sh — fetch and install the latest stable Go toolchain
# tested on Fedora 39-40, Debian/Ubuntu, and Arch; requires curl, tar, sudo
#
# Usage: sudo ./install-go.sh        # installs system-wide
#        ./install-go.sh --user      # installs into $HOME/.local/go

set -euo pipefail
shopt -s nocasematch

################################################################################
# 0. Parse optional flags
################################################################################
PREFIX="/usr/local"      # default system-wide
if [[ $# -ge 1 && $1 == "--user" ]]; then
  PREFIX="$HOME/.local"
  mkdir -p "$PREFIX"
  SUDO=""
else
  SUDO="sudo"
fi

################################################################################
# 1. Discover the latest stable version number (e.g. “go1.24.2”)
################################################################################
echo "→ Detecting latest Go release …"
LATEST=$(curl -fsSL https://go.dev/VERSION?m=text | head -n1)
[[ -z "$LATEST" ]] && { echo "Couldn’t determine latest version"; exit 1; }
echo "  Latest version is $LATEST"

################################################################################
# 2. Map CPU architecture to Go’s naming scheme
################################################################################
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  GOARCH=amd64  ;;
  aarch64) GOARCH=arm64  ;;
  *)       echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

################################################################################
# 3. Download and verify the archive
################################################################################
TARBALL="$LATEST.linux-$GOARCH.tar.gz"
URL="https://go.dev/dl/$TARBALL"
echo "→ Downloading $URL …"
curl -# -fSL "$URL" -o "/tmp/$TARBALL"

################################################################################
# 4. Remove old install and extract new one
################################################################################
echo "→ Installing to $PREFIX/go"
$SUDO rm -rf "$PREFIX/go"
$SUDO tar -C "$PREFIX" -xzf "/tmp/$TARBALL"

################################################################################
# 5. Add Go to PATH if it isn’t already
################################################################################
PROFILE_SNIPPET='export PATH=$PATH:'"$PREFIX"'/go/bin'
SHELL_RC="$HOME/.zshrc"          # adapt if you use bash or fish
if ! grep -q "$PREFIX/go/bin" "$SHELL_RC" 2>/dev/null; then
  echo "→ Appending PATH update to $SHELL_RC"
  echo -e "\n# Go toolchain\n$PROFILE_SNIPPET" >> "$SHELL_RC"
fi

################################################################################
# 6. Clean up and report
################################################################################
rm -f "/tmp/$TARBALL"
echo "✔ Go $LATEST installed. Open a new terminal or run:"
echo "   source $SHELL_RC"
echo "   go version  # should print $LATEST"
