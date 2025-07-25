#!/bin/bash
set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Main installation function
main() {
  print_info "Starting dotfiles installation..."

  # Check OS
  if [[ $OSTYPE != "darwin"* ]]; then
    print_error "This script is only for macOS"
    exit 1
  fi

  # Check and install Nix
  if ! command_exists nix; then
    print_info "Installing Nix package manager..."
    bash <(curl -L https://nixos.org/nix/install) || {
      print_error "Failed to install Nix"
      exit 1
    }

    # Set Nix binary path
    NIX_BIN="/nix/var/nix/profiles/default/bin"
  else
    print_info "Nix is already installed"
    # Set Nix binary path if not already set
    NIX_BIN="/nix/var/nix/profiles/default/bin"
  fi

  # Set dotfiles directory
  DOTFILES_DIR="$HOME/dotfiles"

  # Clone or update dotfiles repository using nix-shell
  if [[ ! -d $DOTFILES_DIR ]]; then
    print_info "Cloning dotfiles repository..."
    if [[ -f "$NIX_BIN/nix-shell" ]]; then
      $NIX_BIN/nix-shell -p git --run "git clone https://github.com/shuntaka9576/dotfiles.git '$DOTFILES_DIR'" || {
        print_error "Failed to clone dotfiles repository"
        exit 1
      }
    else
      print_error "Nix is not properly installed"
      exit 1
    fi
  else
    print_info "Dotfiles directory already exists, pulling latest changes..."
    cd "$DOTFILES_DIR"
    if [[ -f "$NIX_BIN/nix-shell" ]]; then
      $NIX_BIN/nix-shell -p git --run "git pull" || print_warning "Failed to pull latest changes"
    else
      print_warning "Nix not found, skipping git pull"
    fi
  fi

  # Change to dotfiles directory
  cd "$DOTFILES_DIR"

  # Create or fix synthetic.conf
  if [[ ! -f /etc/synthetic.conf ]]; then
    print_info "Creating /etc/synthetic.conf..."
    echo -e "nix\nrun\tprivate/var/run" | sudo tee /etc/synthetic.conf >/dev/null
  fi
  sudo chmod 644 /etc/synthetic.conf

  # Run nix-darwin setup with full path
  print_info "Running nix-darwin setup..."
  if [[ -f "$NIX_BIN/nix" ]]; then
    sudo $NIX_BIN/nix run github:LnL7/nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake ".#shuntaka" || {
      print_error "Failed to run nix-darwin setup"
      exit 1
    }
  else
    print_error "Nix binary not found at $NIX_BIN/nix"
    exit 1
  fi

  # Install mise tools
  print_info "Installing mise tools..."
  if [[ -f "$HOME/.local/bin/mise" ]]; then
    $HOME/.local/bin/mise install || print_warning "Failed to install some mise tools"
  else
    print_warning "mise is not installed yet. Run 'mise install' after restarting your shell"
  fi

  print_info "Installation completed!"
  print_info ""
  print_info "Next steps:"
  print_info "1. Open a new terminal"
  print_info "2. Run: nvim (to install Neovim plugins)"
  print_info "3. Run: gh auth login (for GitHub authentication)"
  print_info "4. Check README.md for additional manual setup steps"
}

# Run main function
main "$@"
