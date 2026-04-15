{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    tmux.enableShellIntegration = true;
  };
}
