#!/bin/bash
query=$(cat | jq -r '.query')
cd "$CLAUDE_PROJECT_DIR"
fd --follow --hidden --no-ignore | fzf --filter="$query" | head -20
