#!/usr/bin/env bash
# Sort tmux windows alphabetically by window name

# Phase 1: move all windows to high indices to avoid collision
i=1000
for wid in $(tmux list-windows -F '#{window_id}'); do
  tmux move-window -s "$wid" -t "$i"
  i=$((i + 1))
done

# Phase 2: move back in alphabetical order
i=0
for wid in $(tmux list-windows -F '#{window_name} #{window_id}' | sort -f | awk '{print $2}'); do
  tmux move-window -s "$wid" -t "$i"
  i=$((i + 1))
done
