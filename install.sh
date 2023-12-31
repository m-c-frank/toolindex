#!/bin/bash

INSTALL_DIR="$HOME/bin"
REPO_URL="https://github.com/m-c-frank/toolindex.git"
# Get the current directory, which is where the script is being run from
REPO_DIR="./toolindex"

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

# Check for required tools and install if necessary
command -v git &> /dev/null || install_package git
command -v gh &> /dev/null || { install_package gh && gh auth login; }

# Clone the repository and install the scripts
git clone "$REPO_URL" "$REPO_DIR" --depth 1 || {
    echo "Failed to clone the toolindex repository."
    exit 1
}

mkdir -p "$INSTALL_DIR"
cp "$REPO_DIR/bin/toolindex" "$INSTALL_DIR/toolindex"
cp -r "$REPO_DIR/src" "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/toolindex"

# Detect the user's shell configuration file
detect_shell_config() {
    local shell_config="$HOME/.bashrc"  # default to .bashrc

    case $SHELL in
        */zsh)
            if [ -f "$HOME/.zshrc" ]; then
                shell_config="$HOME/.zshrc"
            elif [ -f "$HOME/.config/zsh/.zshrc" ]; then
                shell_config="$HOME/.config/zsh/.zshrc"
            fi
            ;;
        */bash)
            # Check for .bash_profile in case of a login shell on macOS or other systems
            if [ -f "$HOME/.bash_profile" ]; then
                shell_config="$HOME/.bash_profile"
            else
                shell_config="$HOME/.bashrc"
            fi
            ;;
        *)
            # Check for .profile if the shell is not bash or zsh
            if [ -f "$HOME/.profile" ]; then
                shell_config="$HOME/.profile"
            fi
            ;;
    esac

    echo "$shell_config"
}

SHELL_CONFIG_FILE=$(detect_shell_config)

if [ ! -f "$SHELL_CONFIG_FILE" ]; then
    read -e -p "The detected shell configuration file ($SHELL_CONFIG_FILE) does not exist. Please provide the path to your actual shell configuration file: " input
    # Expand the tilde to the home directory path
    SHELL_CONFIG_FILE="${input/#\~/$HOME}"
fi

# Update the PATH in the user's shell configuration file if needed
if ! grep -Fxq "export PATH=\"$INSTALL_DIR:\$PATH\"" "$SHELL_CONFIG_FILE"; then
    # Correctly expand the tilde before appending
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "${SHELL_CONFIG_FILE/#\~/$HOME}"
    echo "Updated PATH in $SHELL_CONFIG_FILE"
fi

echo "Installation complete. Please restart your terminal or re-source your shell configuration."
