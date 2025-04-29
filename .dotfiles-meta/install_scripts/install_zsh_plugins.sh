#!/usr/bin/env bash
set -euo pipefail

# where Oh My Zsh custom plugins live (default if unset)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# target plugin directory
PLUGIN_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# 1) Clone the plugin if it’s not already there
if [[ ! -d "$PLUGIN_DIR" ]]; then
  echo "Cloning zsh-autosuggestions into $PLUGIN_DIR…"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGIN_DIR"
else
  echo "zsh-autosuggestions already cloned; pulling latest…"
  git -C "$PLUGIN_DIR" pull --ff-only
fi

# 2) Ensure it's in your ~/.zshrc plugins=(…)
ZSHRC="$HOME/.zshrc"
if ! grep -q "zsh-autosuggestions" "$ZSHRC"; then
  echo "Adding zsh-autosuggestions to plugins in $ZSHRC…"
  # backup before editing
  cp "$ZSHRC" "${ZSHRC}.bak-$(date +%Y%m%d%H%M%S)"
  # insert just before the closing ')' on the plugins line
  sed -i.bak \
    -E "s/^plugins=\(([^)]*)\)/plugins=(\1 zsh-autosuggestions)/" \
    "$ZSHRC"
fi

# 3) Ensure the plugin is sourced at the end of ~/.zshrc
SOURCE_LINE="source \$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
if ! grep -Fxq "$SOURCE_LINE" "$ZSHRC"; then
  echo "Adding source line for zsh-autosuggestions…"
  echo >> "$ZSHRC"
  echo "# load zsh-autosuggestions" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
fi

echo "Done! Reload your shell with \`source ~/.zshrc\` or restart your terminal."
