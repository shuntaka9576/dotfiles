{ pkgs, ... }:
{
  system.stateVersion = 5;
  services.nix-daemon.enable = true;

  # nix = {
  #   optimise.automatic = true;
  #   settings = {
  #     experimental-features = "nix-command flakes";
  #     max-jobs = 8;
  #   };
  # };


  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    casks = [
      "figma"
      # "kindle" # Error: Cask 'kindle' has been disabled because it is discontinued upstream! It was disabled on 2024-12-16.
      "oracle-jdk"
      "visual-studio-code"
      "aws-vault"
      "drawio"
      "ghostty"
      "google-chrome"
      "1password"
      "daisydisk"
      "cursor"
      "insomnia"
      "instantview"
      "ollama"
      "rancher"
      "raspberry-pi-imager"
      "slack"
      "tailscale"
      "wireshark"
      "zap"
      "zoom"
      "mysqlworkbench"
      "chatgpt"
      "claude"
      "cleanshot"
      "alacritty"
      "wezterm"
    ];
  };

  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      orientation = "left";
    };
  };
}
