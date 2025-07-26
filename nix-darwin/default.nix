{ pkgs, ... }:
{
  system.stateVersion = 5;
  system.primaryUser = "shuntaka";
  security.sudo.extraConfig = ''
    shuntaka ALL = (ALL) NOPASSWD: ALL
  '';
  security.pam.services.sudo_local.touchIdAuth = true;
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    taps = [
      {
        name = "shuntaka9576/tap";
        clone_target = "https://github.com/shuntaka9576/homebrew-tap.git";
        force_auto_update = true;
      }
    ];
    brews = [
      "shuntaka9576/tap/blocc"
      "shuntaka9576/tap/trr"
      "docker-credential-helper"
      "ccusage"
    ];
    casks = [
      "windsurf"
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
      "kiro"
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
      "obsidian"
      "wezterm"
      "screen-studio"
      "termius"
    ];
    masApps = {
      "Kindle" = 302584613;
      "CompareMerge" = 478570084;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      CreateDesktop = false;
    };
    dock = {
      autohide = true;
      show-recents = false;
      orientation = "left";
      tilesize = 48;
      magnification = true;
      largesize = 64;
      mineffect = "genie";
      minimize-to-application = true;
      launchanim = true;
      show-process-indicators = true;
      persistent-apps = [
        "/System/Library/CoreServices/Finder.app"
        "/System/Applications/App Store.app"
        "/System/Applications/System Settings.app"
        "/System/Applications/Utilities/Activity Monitor.app"
        "/Applications/WezTerm.app"
        "/Applications/Google Chrome.app"
      ];
    };
  };
}
