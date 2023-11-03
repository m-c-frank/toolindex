#!/bin/bash

INSTALL_DIR="$HOME/bin"
REPO_URL="git@github.com:m-c-frank/toolindex.git"
REPO_DIR="$HOME/.toolindex"

# Function to install git
install_git() {
    read -p "git is not installed. Would you like to install it now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Install git using the preferred package manager
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y git
        elif command -v brew &> /dev/null; then
            brew install git
        # Add other package managers as needed
        else
            echo "Package manager not recognized. Please install git manually."
            exit 1
        fi
    else
        echo "git is required to continue. Exiting."
        exit 1
    fi
}

# Function to install GitHub CLI
install_gh() {
    read -p "GitHub CLI is not installed. Would you like to install it now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Install GitHub CLI using the preferred package manager
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y gh
        elif command -v brew &> /dev/null; then
            brew install gh
        # Add other package managers as needed
        else
            echo "Package manager not recognized. Please install gh manually."
            exit 1
        fi
    else
        echo "GitHub CLI is required to continue. Exiting."
        exit 1
    fi
}

# Check if git is installed, if not, offer to install
if ! command -v git &> /dev/null; then
    install_git
fi

# Check if gh is installed and authenticated
if ! command -v gh &> /dev/null; then
    install_gh
fi

if ! gh auth status &> /dev/null; then
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

chmod +x "$INSTALL_DIR"/{toolindex,fetch_abstracts.sh,format_abstracts.sh}

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.bashrc"
fi

echo "Installation complete. Please restart your terminal or source your .bashrc file."
