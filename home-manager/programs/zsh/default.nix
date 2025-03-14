{ pkgs, username, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      n = "nvim";
      l = "lazygit";
      ls = "eza";
      ll = "eza -ahl --git";
      t = "tmux -2";
      tree = "eza -T --git-ignore";
      ne = "nix eval -f";
      me = "memo e";
      mn = "memo new";
      tka = "tmux kill-server";
      u = "nix run github:LnL7/nix-darwin -- switch --flake \".#${username}\"";
      x = ''
        tmux rename-window "$(basename `pwd` | cut -c1-4)";
        tmux new-window -n "n" nvim;
        tmux new-window -n "p";
        lazygit
      '';
    };
    autosuggestion.enable = true;
    prezto = {
      enable = true;
      prompt = {
        theme = "pure";
      };
    };
    initExtra = ''
      ${builtins.readFile ./.zshrc}
    '';
  };
}
