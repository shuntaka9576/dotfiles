{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };
}
