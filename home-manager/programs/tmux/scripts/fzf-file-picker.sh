#!/usr/bin/env bash

pane_id="$1"

result=$(fd --follow --hidden --exclude .git | fzf --multi --layout=reverse \
  --prompt='Files> ' \
  --header='C-s: toggle grep mode' \
  --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}' \
  --preview-window=right:60% \
  --bind 'start:unbind(change)' \
  --bind 'change:reload:rg --files-with-matches --hidden --glob "!.git" --color=never -- {q} 2>/dev/null || true' \
  --bind 'ctrl-s:transform:[[ $FZF_PROMPT == "Files> " ]] && echo "change-prompt(Grep> )+disable-search+clear-query+reload(: || true)+rebind(change)" || echo "change-prompt(Files> )+enable-search+clear-query+unbind(change)+reload(fd --follow --hidden --exclude .git)"' \
  | sed 's|^|@|' | tr '\n' ' ' | sed 's/ $//' || true)

if [ -n "$result" ]; then
  tmux set-buffer -- "$result"
  tmux paste-buffer -t "$pane_id"
fi
