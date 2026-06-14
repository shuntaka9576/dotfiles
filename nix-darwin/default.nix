{
  pkgs,
  lib,
  config,
  ...
}:
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
      {
        name = "kayac/tap";
        clone_target = "https://github.com/kayac/homebrew-tap";
        force_auto_update = true;
      }
      {
        name = "productdevbook/tap";
        clone_target = "https://github.com/productdevbook/homebrew-tap";
        force_auto_update = true;
      }
      {
        name = "microsoft/apm";
        clone_target = "https://github.com/microsoft/homebrew-apm";
        force_auto_update = true;
      }
      {
        name = "helvesec/rmux";
        clone_target = "https://github.com/Helvesec/homebrew-rmux";
        force_auto_update = true;
      }
    ];
    brews = [
      "shuntaka9576/tap/blocc"
      "shuntaka9576/tap/trr"
      "shuntaka9576/tap/ddbrew"

      "kayac/tap/ecspresso"
      "microsoft/apm/apm"
      "helvesec/rmux/rmux"
      "docker-credential-helper"
      "postgresql"
      "pstree"
      "watch"
      "btop"
      "htop"
      "actionlint"
      "libsixel"
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
      "1password-cli"
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
      "aqua-voice"
      "codex-app"
      "nani"
      "google-gemini"
      "productdevbook/tap/portkiller"
    ];
    masApps = {
      "Kindle" = 302584613;
      "CompareMerge" = 478570084;
    };
  };

  # Homebrew 6.0+ refuses to load formulae/casks from untrusted non-official taps.
  # extraActivation runs before the homebrew activation script, so trust them here.
  # Replace with homebrew.taps `trusted = true` once nix-darwin#1789 is merged.
  system.activationScripts.extraActivation.text = ''
    if [ -f /opt/homebrew/bin/brew ]; then
      echo >&2 "Trusting Homebrew taps..."
      PATH="/opt/homebrew/bin:$PATH" \
      sudo \
        --preserve-env=PATH \
        --user=shuntaka \
        --set-home \
        /opt/homebrew/bin/brew trust --tap ${lib.escapeShellArgs (map (t: t.name) config.homebrew.taps)}
    fi
  '';

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
    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      StandardHideDesktopIcons = true;
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
        "/Applications/Codex.app"
      ];
    };
  };
}
