{
  username,
  homeDirectory,
  lib,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = lib.mkForce homeDirectory;
    stateVersion = "24.11";
  };

  xdg.enable = true;

  imports = [
    ./programs/alacritty/default.nix
    ./programs/cargo/default.nix
    ./programs/claude/default.nix
    ./programs/deno/default.nix
    ./programs/fzf/default.nix
    ./programs/gh/default.nix
    ./programs/haskell/default.nix
    ./programs/git/default.nix
    ./programs/lazygit/default.nix
    ./programs/mcp/default.nix
    ./programs/memo/default.nix
    ./programs/mise/default.nix
    ./programs/nvim/default.nix
    ./programs/packages/default.nix
    ./programs/pet/default.nix
    ./programs/tmux/default.nix
    ./programs/vhs/default.nix
    ./programs/vscode/default.nix
    ./programs/wezterm/default.nix
    ./programs/zellij/default.nix
    ./programs/zsh/default.nix
  ];

  programs.home-manager.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      cores = 0;
      trusted-users = [ username ];
    };

    gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
