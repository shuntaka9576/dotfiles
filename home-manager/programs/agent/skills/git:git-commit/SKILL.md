---
name: git:git-commit
description: Git Commit
---

# Git Commit

## Step 1: Check Branch
1. Get the current branch: `git branch --show-current`
2. Ask the user using AskUserQuestionTool: "Do you want to create a new branch?" (default: No)

## Step 2: Sync with Remote (automatic)
1. Run `git fetch` to fetch remote
2. If there are differences from remote HEAD, run `git pull` automatically

## Step 3: Create Branch (if requested)
1. Analyze staged changes with `git diff --cached`
2. Conventional Commits format: `<type>/<short-description>`
3. Run `git checkout -b <branch-name>`

## Commit Workflow
1. Analyze staged changes with `git diff --cached`
2. If there are no staged changes, notify and exit
3. Check commit style with `git log`
4. Please write a comprehensive commit message based on git diff
5. Run `git commit -m "message"`

## Constraints
- Never run `git add`
- Only work with staged changes
