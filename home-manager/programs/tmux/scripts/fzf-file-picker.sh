#!/usr/bin/env bash

pane_id="$1"
log="/tmp/fzf-picker-debug.log"

echo "pane_id: [$pane_id]" >"$log"

result=$(fd --follow --hidden --exclude .git | fzf --multi --layout=reverse \
  --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}' \
  --preview-window=right:60% |
  sed 's|^|@|' | tr '\n' ' ' | sed 's/ $//' || true)

echo "result: [$result]" >>"$log"

if [ -n "$result" ]; then
  tmux set-buffer -- "$result" 2>>"$log"
  echo "set-buffer exit: $?" >>"$log"
  tmux paste-buffer -t "$pane_id" 2>>"$log"
  echo "paste-buffer exit: $?" >>"$log"
fi
