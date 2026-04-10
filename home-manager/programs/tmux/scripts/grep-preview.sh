#!/usr/bin/env bash
query="$1"
file="$2"

if [[ -z $query || -z $file ]]; then
  bat --color=always --style=numbers "$file" 2>/dev/null || cat "$file"
  exit 0
fi

# Get matching line numbers
mapfile -t lines < <(rg --line-number --no-heading --color=never -I -- "$query" "$file" 2>/dev/null | cut -d: -f1 | head -20)

if [[ ${#lines[@]} -eq 0 ]]; then
  bat --color=always --style=numbers "$file" 2>/dev/null || cat "$file"
  exit 0
fi

# Build --highlight-line flags
hl_flags=()
for l in "${lines[@]}"; do
  hl_flags+=(--highlight-line "$l")
done

bat --color=always --style=numbers "${hl_flags[@]}" "$file" 2>/dev/null || cat "$file"
