#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION_FILE="${SCRIPT_DIR}/.claude-version"

if [[ -f $VERSION_FILE ]]; then
  CLAUDE_VERSION="$(cat "$VERSION_FILE" | tr -d '[:space:]')"
else
  echo "Error: .claude-version file not found"
  exit 1
fi

echo "Installing Claude Code CLI v${CLAUDE_VERSION}..."
curl -fsSL https://claude.ai/install.sh | bash -s "${CLAUDE_VERSION}"

if command -v claude &>/dev/null; then
  claude --version
else
  echo "Error: claude command not found"
  exit 1
fi
