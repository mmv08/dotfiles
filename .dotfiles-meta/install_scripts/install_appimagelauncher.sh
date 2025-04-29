#!/usr/bin/env bash

set -euo pipefail

# Variables
VERSION="3.0.0-alpha-4"
ARCH="x86_64"
TMP_DIR="/tmp"
RPM_NAME="appimagelauncher-${VERSION}.${ARCH}.rpm"
DOWNLOAD_URL="https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-alpha-4/appimagelauncher_3.0.0-alpha-4-gha253.36951ec_x86_64.rpm"
RPM_PATH="${TMP_DIR}/${RPM_NAME}"

# Function to check if the package is already installed
is_package_installed() {
    rpm -q appimagelauncher &>/dev/null
}

# Main installation function
install_appimagelauncher() {
    echo "Checking if AppImageLauncher is already installed..."
    if is_package_installed; then
        echo "AppImageLauncher is already installed."
        return
    fi

    echo "Downloading AppImageLauncher v${VERSION} RPM to ${TMP_DIR}..."
    curl -L -o "${RPM_PATH}" "${DOWNLOAD_URL}"

    echo "Installing AppImageLauncher..."
    sudo dnf install -y "${RPM_PATH}"

    echo "Cleaning up..."
    rm -f "${RPM_PATH}"

    echo "AppImageLauncher v${VERSION} has been installed successfully."
}

# Execute the installation
install_appimagelauncher
