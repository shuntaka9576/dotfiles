#!/bin/bash
query=$(cat | jq -r '.query')
cd "$CLAUDE_PROJECT_DIR"
rg --files --hidden | grep -i "$query" | head -20
