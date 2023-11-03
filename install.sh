#!/bin/bash

INSTALL_DIR="$HOME/bin"
REPO_URL="https://github.com/m-c-frank/toolindex.git"
REPO_DIR="$HOME/.toolindex"

# Function to install a package using pacman
install_package() {
    local package=$1
    echo "$package is not installed."
    read -p "Would you like to install $package now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo pacman -Syu --needed "$package"
    else
        echo "$package is required to continue. Exiting."
        exit 1
    fi
}

# Check if git is installed, if not, offer to install
command -v git &> /dev/null || install_package git

# Check if GitHub CLI is installed, if not, offer to install
if ! command -v gh &> /dev/null; then
    install_package gh
    # Authenticate with GitHub after installation
    gh auth login
fi

# Clone the repository and install the scripts
git clone "$REPO_URL" "$REPO_DIR" || {
    echo "Failed to clone the toolindex repository."
    exit 1
}

mkdir -p "$INSTALL_DIR"
cp "$REPO_DIR/bin/toolindex.sh" "$INSTALL_DIR/toolindex"
cp "$REPO_DIR/src/fetch_abstracts.sh" "$INSTALL_DIR/"
cp "$REPO_DIR/src/format_abstracts.sh" "$INSTALL_DIR/"

chmod +x "$INSTALL_DIR"/toolindex "$INSTALL_DIR"/fetch_abstracts.sh "$INSTALL_DIR"/format_abstracts.sh

# Check if the install directory is in the PATH, add it if not
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "Added $INSTALL_DIR to PATH"
fi

echo "Installation complete. Please restart your terminal or source your .bashrc file."
