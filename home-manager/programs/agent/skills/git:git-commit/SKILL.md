---
name: git:git-commit
description: Git コミット
---

# Git コミット

## ステップ 1: ブランチ確認
1. 現在のブランチを取得: `git branch --show-current`
2. AskUserQuestionToolを使ってユーザーに確認: 「新しいブランチを作成しますか？」（デフォルト: いいえ）

## ステップ 2: リモート同期（自動実行）
1. `git fetch` でリモートを取得
2. リモートHEADと差分があれば `git pull` を自動実行

## ステップ 3: ブランチ作成（要求された場合）
1. `git diff --cached` でステージされた変更を分析
2. Conventional Commits形式: `<type>/<short-description>`
3. `git checkout -b <branch-name>`

## コミットワークフロー
1. `git diff --cached` でステージされた変更を分析
2. ステージされた変更がない場合は通知して終了
3. `git log` でコミットスタイルを確認
4. `git commit -m "message"` を実行

## 制約
- `git add` は絶対に実行しない
- ステージ済みの変更のみを対象とする
