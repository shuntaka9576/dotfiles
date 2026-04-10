#!/usr/bin/env bash
set -euo pipefail

# Pull only if upstream tracking branch exists
if git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null; then
  git pull
fi

DIFF=$(git diff --cached)
LOG=$(git log --oneline -20)

MSG=$(echo "$DIFF" | claude --no-session-persistence --print --model haiku "Here are the recent commits in this repository:
$LOG

Based on the commit style above and the diff from stdin, write a comprehensive Git commit message. Use Conventional Commits format (type(scope): description). Output ONLY the commit message. Do NOT wrap in backticks or any markdown formatting.")

git commit -e -m "$MSG"
