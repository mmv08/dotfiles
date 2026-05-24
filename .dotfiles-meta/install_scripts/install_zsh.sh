#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/utils.sh"

PLUGINS_ONLY="${DOTFILES_ZSH_PLUGINS_ONLY:-0}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

canonical_path() {
  local path="$1"

  readlink -f "$path" 2>/dev/null || printf '%s\n' "$path"
}

shell_is_allowed() {
  local expected_shell="$1"
  local shell

  while IFS= read -r shell; do
    [[ -z "$shell" || "$shell" == \#* ]] && continue

    if [ "$(canonical_path "$shell")" = "$expected_shell" ]; then
      return 0
    fi
  done < /etc/shells

  return 1
}

set_zsh_as_login_shell() {
  local zsh_path
  local zsh_shell
  local target_user
  local passwd_entry
  local current_shell

  if [ "${CI:-false}" = "true" ]; then
    echo "Skipping login shell change in CI"
    return 0
  fi

  zsh_path="$(command -v zsh)"
  zsh_shell="$(canonical_path "$zsh_path")"
  target_user="${SUDO_USER:-${USER:-}}"

  if [ -z "$target_user" ]; then
    target_user="$(id -un)"
  fi

  if [ "$target_user" = "root" ]; then
    echo "Skipping login shell change for root"
    return 0
  fi

  passwd_entry="$(getent passwd "$target_user" || true)"
  if [ -z "$passwd_entry" ]; then
    echo "Could not determine login shell for $target_user" >&2
    return 1
  fi

  IFS=: read -r _ _ _ _ _ _ current_shell _ <<< "$passwd_entry"
  if [ "$(canonical_path "$current_shell")" = "$zsh_shell" ]; then
    echo "Login shell already set to zsh"
    return 0
  fi

  if ! shell_is_allowed "$zsh_shell"; then
    echo "$zsh_path is not listed in /etc/shells; refusing to set it as the login shell" >&2
    return 1
  fi

  echo "Changing login shell for $target_user from $current_shell to $zsh_path..."
  if command_exists chsh; then
    sudo chsh -s "$zsh_path" "$target_user"
  else
    sudo usermod --shell "$zsh_path" "$target_user"
  fi
  echo "Login shell changed to zsh; start a new login session for it to take effect"
}

install_plugin() {
  local repo_url="$1"
  local plugin_dir="$2"

  if [ -d "$plugin_dir" ]; then
    git -C "$plugin_dir" pull --ff-only
    return 0
  fi

  git clone "$repo_url" "$plugin_dir"
}

install_zsh_plugins() {
  install_plugin "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  install_plugin "https://github.com/fdellwing/zsh-bat.git" \
    "$ZSH_CUSTOM/plugins/zsh-bat"
}

if [ "$PLUGINS_ONLY" = "1" ]; then
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is not installed. Run install_zsh.sh first."
    exit 1
  fi

  install_zsh_plugins
  echo "Zsh plugins installation completed"
  exit 0
fi

install_package_if_missing zsh

# Save our custom .zshrc if it exists (either from dotfiles or backup from bootstrap)
ZSHRC_TEMP=""
if [ -f "$HOME/.zshrc" ]; then
  ZSHRC_TEMP=$(mktemp /tmp/zshrc.XXXXXX)
  cp "$HOME/.zshrc" "$ZSHRC_TEMP"
  echo "Saved existing .zshrc to temporary location"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  export KEEP_ZSHRC=yes RUNZSH=no CHSH=no
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Oh My Zsh overwrites .zshrc even with KEEP_ZSHRC=yes, so we restore ours
  if [ -n "$ZSHRC_TEMP" ] && [ -f "$ZSHRC_TEMP" ]; then
    echo "Restoring custom .zshrc..."
    cp "$ZSHRC_TEMP" "$HOME/.zshrc"
    echo "Custom .zshrc restored successfully"
  fi
else
  echo "Oh My Zsh already installed"
fi

# Clean up temp file
[ -n "$ZSHRC_TEMP" ] && rm -f "$ZSHRC_TEMP"

# If we have a backup from bootstrap.sh, restore it
if [ -n "${DOTFILES_ZSHRC_BACKUP:-}" ] && [ -f "$DOTFILES_ZSHRC_BACKUP" ]; then
  echo "Restoring .zshrc from bootstrap backup..."
  cp "$DOTFILES_ZSHRC_BACKUP" "$HOME/.zshrc"
  echo "Bootstrap .zshrc restored successfully"
fi

set_zsh_as_login_shell

install_zsh_plugins
echo "Zsh plugin installation completed"
