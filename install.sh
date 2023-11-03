#!/bin/bash

# Define the install directory
INSTALL_DIR="$HOME/bin"
REPO_URL="git@github.com:yourusername/toolindex.git"
REPO_DIR="$HOME/.toolindex"

# Ensure git is installed
if ! command -v git &> /dev/null; then
    echo "git is not installed. Please install git and try again."
    exit 1
fi

# Ensure gh is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI is not installed. Please install gh and try again."
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "GitHub CLI is not authenticated. Please login with 'gh auth login'."
    exit 1
fi

# Clone the repository
git clone "$REPO_URL" "$REPO_DIR" || {
    echo "Failed to clone the toolindex repository."
    exit 1
}

# Create bin directory if it doesn't exist and copy scripts
mkdir -p "$INSTALL_DIR"
cp "$REPO_DIR/bin/toolindex.sh" "$INSTALL_DIR/toolindex"
cp "$REPO_DIR/src/fetch_abstracts.sh" "$INSTALL_DIR/"
cp "$REPO_DIR/src/format_abstracts.sh" "$INSTALL_DIR/"

# Make the scripts executable
chmod +x "$INSTALL_DIR"/{toolindex,fetch_abstracts.sh,format_abstracts.sh}

# Check if the install directory is in the PATH, add it if not
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "Added $INSTALL_DIR to PATH"
fi

echo "Installation complete. Please restart your terminal or run 'source ~/.bashrc'."
