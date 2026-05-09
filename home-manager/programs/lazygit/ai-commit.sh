#!/usr/bin/env bash
set -euo pipefail

# Pull only if upstream tracking branch exists
if git rev-parse --abbrev-ref --symbolic-full-name @{upstream} >/dev/null 2>&1; then
  git pull --quiet
fi

DIFF=$(git diff --cached)
if [ -z "$DIFF" ]; then
  echo "Error: No staged changes to commit" >&2
  exit 1
fi

LOG=$(git log --oneline -20)

echo "Generating commit message via claude..." >&2
set +e
MSG=$(echo "$DIFF" | claude --no-session-persistence --print --model haiku "Here are the recent commits in this repository:
$LOG

Based on the commit style above and the diff from stdin, write a comprehensive Git commit message. Use Conventional Commits format without scope (type: description). Output ONLY the commit message. Do NOT wrap in backticks or any markdown formatting.")
STATUS=$?
set -e

if [ "$STATUS" -ne 0 ]; then
  echo "Error: claude exited with status $STATUS" >&2
  exit "$STATUS"
fi

if [ -z "$MSG" ]; then
  echo "Error: claude returned empty commit message" >&2
  exit 1
fi

git commit -m "$MSG"
