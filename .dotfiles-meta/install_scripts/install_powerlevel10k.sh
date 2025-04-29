#!/usr/bin/env bash
#
# install-powerlevel10k.sh — install or update the Powerlevel10k ZSH theme
# works on any distro where ZSH + Oh-My-Zsh are available
#
# Usage: bash install-powerlevel10k.sh

set -euo pipefail

###############################################################################
# 1. Preconditions
###############################################################################
command -v zsh >/dev/null || { echo "❌ zsh not found. Install zsh first."; exit 1; }

if [[ -z ${ZSH:-} ]]; then
  ZSH="$HOME/.oh-my-zsh"
fi
if [[ ! -d "$ZSH" ]]; then
  echo "❌ Oh-My-Zsh not found in $ZSH"
  echo "   Install it with: RUNZSH=no KEEP_ZSHRC=yes sh -c \"$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
  exit 1
fi

###############################################################################
# 2. Fetch or update the theme
###############################################################################
THEME_DIR="${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k"
if [[ -d "$THEME_DIR/.git" ]]; then
  echo "→ Updating powerlevel10k …"
  git -C "$THEME_DIR" pull --ff-only
else
  echo "→ Cloning powerlevel10k …"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
fi

###############################################################################
# 3. Ensure ZSH_THEME is set correctly
###############################################################################
ZSHRC="$HOME/.zshrc"
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
  echo "→ Updating existing ZSH_THEME line in $ZSHRC"
  # use | as the delimiter so the slash in powerlevel10k/powerlevel10k is harmless
  sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
else
  echo "→ Adding ZSH_THEME line to $ZSHRC"
  printf '\n# Powerlevel10k theme\nZSH_THEME="powerlevel10k/powerlevel10k"\n' >> "$ZSHRC"
fi

###############################################################################
# 4. Fin
###############################################################################
echo "✔ Powerlevel10k installed. Start a new ZSH session or run: exec zsh"
echo "  First launch will open the configuration wizard; tweak as desired."
