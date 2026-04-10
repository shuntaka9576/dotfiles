#!/usr/bin/env bash
query="$1"
file="$2"

if [[ -z $query || -z $file ]]; then
  bat --color=always --style=numbers "$file" 2>/dev/null || cat "$file"
  exit 0
fi

# Use rg --passthru to highlight matched text inline (bold red) while showing all lines
rg --passthru --color=always --line-number -- "$query" "$file" 2>/dev/null || bat --color=always --style=numbers "$file" 2>/dev/null || cat "$file"
