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

# Build --highlight-line flags and center on first match
hl_flags=()
for l in "${lines[@]}"; do
  hl_flags+=(--highlight-line "$l")
done

# Show file centered on first match with syntax highlighting
first_line="${lines[0]}"
start=$((first_line - 10))
[[ $start -lt 1 ]] && start=1

bat --color=always --style=numbers,header --line-range "$start:" --highlight-line "${lines[0]}" "${hl_flags[@]}" "$file" 2>/dev/null || cat "$file"
