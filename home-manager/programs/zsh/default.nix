{ pkgs, username, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      rm = "rm";
      # NOTE: Stopped passing /plan because it pollutes conversation history
      # c = "claude --chrome --dangerously-skip-permissions <<< '/plan'";
      c = "claude --chrome --dangerously-skip-permissions";
      co = "codex";
      n = "nvim";
      l = "lazygit";
      ls = "eza";
      ll = "eza -ahl --git";
      t = "tmux -2";
      tree = "eza -T --git-ignore";
      ne = "nix eval -f";
      me = "memo e";
      mn = "cd ~/repos/github.com/shuntaka9576/memo && memo new";
      tka = "tmux kill-server";
      ecs = "ecspresso";
      x = ''
        tmux rename-window "$(basename `pwd` | cut -c1-4)";
        tmux new-window -n "n" "zsh -c 'nvim; exec zsh'";
        tmux new-window -n "p";
        WIN_NAME="cc-$(basename `pwd` | cut -c1-4)";
        tmux new-window -n "$WIN_NAME";
        sleep 0.1;
        tmux split-window -h -t "$WIN_NAME";
        sleep 0.1;
        tmux split-window -h -t "$WIN_NAME.1";
        sleep 0.1;
        tmux select-layout -t "$WIN_NAME" even-horizontal;
        sleep 0.1;
        tmux send-keys -t "$WIN_NAME.0" "c" C-m;
        lazygit
      '';
      # d = ''
      #   _dir="$(basename "$(pwd)")";
      #   _toplevel="$(git rev-parse --show-toplevel 2>/dev/null)";
      #   _repo="$(basename "$(dirname "$_toplevel")")";
      #   if [[ "$_dir" == "$_repo" ]]; then
      #     WIN_NAME="$(echo "$_dir" | cut -c1-15)";
      #   else
      #     WIN_NAME="$(echo "$(echo "$_repo" | cut -c1-3)-$(echo "$_dir" | sed 's/^wip-//'))" | cut -c1-15)";
      #   fi
      #   WIN_ID=$(tmux new-window -n "$WIN_NAME" -P -F "#{window_id}");
      #   sleep 0.1;
      #   tmux split-window -h -p 75 -t "$WIN_ID";
      #   sleep 0.1;
      #   tmux split-window -h -p 87 -t "$WIN_ID.1";
      #   sleep 0.1;
      #   tmux split-window -h -p 61 -t "$WIN_ID.2";
      #   sleep 0.1;
      #   tmux send-keys -t "$WIN_ID.0" "c" C-m;
      #   tmux send-keys -t "$WIN_ID.1" "lazygit" C-m;
      #   tmux send-keys -t "$WIN_ID.2" "c" C-m;
      #   tmux send-keys -t "$WIN_ID.3" "nvim +DiffviewOpen" C-m;
      #   tmux select-pane -t "$WIN_ID.2"
      # '';
      d = ''
        _dir="$(basename "$(pwd)")";
        _toplevel="$(git rev-parse --show-toplevel 2>/dev/null)";
        _repo="$(basename "$(dirname "$_toplevel")")";
        if [[ "$_dir" == "$_repo" ]]; then
          WIN_NAME="$(echo "$_dir" | cut -c1-15)";
        else
          WIN_NAME="$(echo "$(echo "$_repo" | cut -c1-3)-$(echo "$_dir" | sed 's/^wip-//'))" | cut -c1-15)";
        fi
        # Rename current window and split for nvim
        tmux rename-window "$WIN_NAME";
        tmux split-window -h -p 64 -c "$PWD";
        sleep 0.1;
        tmux send-keys "nvim +'autocmd VimEnter * ++once NvimTreeToggle'" C-m;
        # Window 2: claude(25) + claude(25) + zsh(50)
        WIN2_ID=$(tmux new-window -P -F "#{window_id}" -c "$PWD");
        tmux rename-window -t "$WIN2_ID" "p";
        sleep 0.1;
        tmux split-window -h -p 75 -t "$WIN2_ID" -c "$PWD";
        sleep 0.1;
        tmux split-window -h -p 67 -t "$WIN2_ID.1" -c "$PWD";
        sleep 0.1;
        tmux send-keys -t "$WIN2_ID.0" "c" C-m;
        tmux send-keys -t "$WIN2_ID.1" "c" C-m;
        tmux select-pane -t "$WIN2_ID.1";
        # Run lazygit directly in the current pane (left side of the original window)
        lazygit
      '';
    };
    autosuggestion.enable = true;
    prezto = {
      enable = true;
      prompt = {
        theme = "off";
      };
    };
    initContent = ''
      ${builtins.readFile ./.zshrc}
    '';
  };
}
