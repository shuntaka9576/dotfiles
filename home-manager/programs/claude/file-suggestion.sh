#!/bin/bash
query=$(cat | jq -r '.query')
cd "$CLAUDE_PROJECT_DIR"
rg --files --hidden | fzf --filter="$query" | head -20
