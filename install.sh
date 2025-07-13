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

    # Source Nix environment
    if [[ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    elif [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
      . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
  else
    print_info "Nix is already installed"
  fi

  # Set dotfiles directory
  DOTFILES_DIR="$HOME/dotfiles"

  # Clone or update dotfiles repository
  if [[ ! -d $DOTFILES_DIR ]]; then
    print_info "Cloning dotfiles repository..."
    git clone https://github.com/shuntaka9576/dotfiles.git "$DOTFILES_DIR" || {
      print_error "Failed to clone dotfiles repository"
      exit 1
    }
  else
    print_info "Dotfiles directory already exists, pulling latest changes..."
    cd "$DOTFILES_DIR"
    git pull || print_warning "Failed to pull latest changes"
  fi

  # Change to dotfiles directory
  cd "$DOTFILES_DIR"

  # Create or fix synthetic.conf
  if [[ ! -f /etc/synthetic.conf ]]; then
    print_info "Creating /etc/synthetic.conf..."
    echo -e "nix\nrun\tprivate/var/run" | sudo tee /etc/synthetic.conf > /dev/null
  fi
  sudo chmod 644 /etc/synthetic.conf

  # Run make init
  print_info "Running nix-darwin setup..."
  make init || {
    print_error "Failed to run make init"
    exit 1
  }

  # Install mise tools
  if command_exists mise; then
    print_info "Installing mise tools..."
    mise install || print_warning "Failed to install some mise tools"
  else
    print_warning "mise is not installed yet. Run 'mise install' after restarting your shell"
  fi

  print_info "Installation completed!"
  print_info ""
  print_info "Next steps:"
  print_info "1. Restart your terminal or run: source ~/.zshrc"
  print_info "2. Run: nvim (to install Neovim plugins)"
  print_info "3. Run: gh auth login (for GitHub authentication)"
  print_info "4. Check README.md for additional manual setup steps"
}

# Run main function
main "$@"
