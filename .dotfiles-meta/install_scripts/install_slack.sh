#!/usr/bin/env bash
set -euo pipefail

install_slack_rpm() {
  if command -v slack &> /dev/null; then
    echo "Slack is already installed."
    return
  fi

  echo "Downloading Slack RPM..."
  wget -qO /tmp/slack.rpm https://downloads.slack-edge.com/desktop-releases/linux/x64/4.43.51/slack-4.43.51-0.1.el8.x86_64.rpm

  echo "Installing Slack..."
  sudo dnf install -y /tmp/slack.rpm
}

install_slack_rpm
