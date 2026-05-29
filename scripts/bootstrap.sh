#!/usr/bin/env sh
# Ensure make is available. Run once on a new machine before using the Makefile.
set -e

check_make() {
    command -v make >/dev/null 2>&1
}

if check_make; then
    echo "make already available: $(make --version | head -1)"
    exit 0
fi

OS="$(uname -s)"
case "$OS" in
    Darwin)
        if command -v brew >/dev/null 2>&1; then
            echo "Installing make via Homebrew..."
            brew install make
        else
            echo "Installing Xcode Command Line Tools (includes make)..."
            xcode-select --install
            echo "Re-run this script after the installation completes."
            exit 0
        fi
        ;;
    Linux)
        if command -v apt-get >/dev/null 2>&1; then
            echo "Installing make via apt..."
            sudo apt-get update -q && sudo apt-get install -y make
        else
            echo "Unsupported Linux package manager. Install make manually."
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS: $OS. Install make manually."
        exit 1
        ;;
esac

if check_make; then
    echo "make installed: $(make --version | head -1)"
else
    echo "Installation finished but make not found in PATH. Restart your shell."
fi
