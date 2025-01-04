{ pkgs, ... }:
{
  system.stateVersion = 5;
  services.nix-daemon.enable = true;
  security.sudo.extraConfig = ''
    shuntaka ALL = (ALL) NOPASSWD: ALL
  '';
  security.pam.enableSudoTouchIdAuth = true;
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    casks = [
      "figma"
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
