{ pkgs, username, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      c = "claude --dangerously-skip-permissions";
      cgm = "c -p '過去のコミットメッセージを参考に、フォーマットを揃えてコミットを作ってください'";
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
    initContent = ''
      ${builtins.readFile ./.zshrc}
    '';
  };
}
