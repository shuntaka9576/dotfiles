{
  pkgs,
  username,
  config,
  ...
}:
let
  claudeBase = "claude --chrome --dangerously-skip-permissions --teammate-mode tmux --enable-auto-mode";
in
{
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    shellAliases = {
      rm = "rm";
      # NOTE: Stopped passing /plan because it pollutes conversation history
      # c = "claude --chrome --dangerously-skip-permissions <<< '/plan'";
      c = claudeBase;
      co = "codex";
      cm = "cargo make";
      o = "opencode";
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
      "..." = "cd ../..";
      ecs = "ecspresso";
      aic = "bash ~/dotfiles/home-manager/programs/lazygit/ai-commit.sh";
      wsc = "wt switch --create";
      wd = ''
        DEPLOY_PATH=$(wt list --format=json | jq -r '.[] | select(.branch == "deploy") | .path')
        if [ -z "$DEPLOY_PATH" ]; then
          echo "deploy worktree not found. Creating..."
          wt switch --create deploy --no-cd -y
          DEPLOY_PATH=$(wt list --format=json | jq -r '.[] | select(.branch == "deploy") | .path')
        fi
        git -C "$DEPLOY_PATH" checkout --detach "$(git rev-parse HEAD)"
      '';
      an = "agentoast send --badge Done --badge-color green --tmux-pane $TMUX_PANE";
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
      d = ''
        _dir=''${PWD:t};
        _toplevel="$(git rev-parse --show-toplevel 2>/dev/null)";
        _repo=''${_toplevel:h:t};
        if [[ "$_dir" == "$_repo" ]]; then
          WIN_NAME=''${_dir[1,15]};
        else
          WIN_NAME="''${_repo[1,3]}-''${_dir#wip-}";
          WIN_NAME=''${WIN_NAME[1,15]};
        fi
        NVIM_PANE=$(tmux display-message -p "#{pane_id}");
        tmux rename-window "$WIN_NAME" \; split-window -v -p 20 -c "$PWD" \; select-pane -t "$NVIM_PANE";
        CLAUDE_TOP=$(tmux split-window -h -p 50 -c "$PWD" -P -F "#{pane_id}");
        CLAUDE_BOTTOM=$(tmux split-window -h -p 50 -c "$PWD" -P -F "#{pane_id}");
        tmux send-keys -t "$NVIM_PANE" "nvim +'autocmd VimEnter * ++once NvimTreeToggle'" C-m \; send-keys -t "$CLAUDE_TOP" "c" C-m \; send-keys -t "$CLAUDE_BOTTOM" "c" C-m \; select-pane -t "$CLAUDE_TOP";
      '';
      dc = ''
        _dir=''${PWD:t};
        _toplevel="$(git rev-parse --show-toplevel 2>/dev/null)";
        _repo=''${_toplevel:h:t};
        if [[ "$_dir" == "$_repo" ]]; then
          WIN_NAME=''${_dir[1,15]};
        else
          WIN_NAME="''${_repo[1,3]}-''${_dir#wip-}";
          WIN_NAME=''${WIN_NAME[1,15]};
        fi
        NVIM_PANE=$(tmux display-message -p "#{pane_id}");
        tmux rename-window "$WIN_NAME" \; split-window -v -p 20 -c "$PWD" \; select-pane -t "$NVIM_PANE";
        CLAUDE_TOP=$(tmux split-window -h -p 50 -c "$PWD" -P -F "#{pane_id}");
        CLAUDE_BOTTOM=$(tmux split-window -h -p 50 -c "$PWD" -P -F "#{pane_id}");
        tmux send-keys -t "$NVIM_PANE" "nvim +'autocmd VimEnter * ++once NvimTreeToggle'" C-m \; send-keys -t "$CLAUDE_TOP" "co" C-m \; send-keys -t "$CLAUDE_BOTTOM" "c" C-m \; select-pane -t "$CLAUDE_TOP";
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
