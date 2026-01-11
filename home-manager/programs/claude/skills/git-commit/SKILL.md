---
name: git-commit
description: ステージされた変更とリポジトリのコミット履歴パターンに基づいてgitコミットを作成。コミット作成時、変更のコミット時、ステージされたファイルのレビュー時に使用。
---

# Git コミット

## コミット前ワークフロー

### ステップ 1: ブランチ確認
1. 現在のブランチを取得: `git branch --show-current`
2. ユーザーに確認: 「新しいブランチを作成しますか？（はい/いいえ）」

### ステップ 2: リモート同期
1. リモートをフェッチ: `git fetch`
2. 遅れているか確認: `git status -uno`
3. 更新があれば `git pull` を実行

### ステップ 3: ブランチ作成（要求された場合）
1. `git diff --cached` でステージされた変更を分析
2. Conventional Commits に準拠したブランチ名を生成:
   - 形式: `<type>/<short-description>`
   - タイプ: feat, fix, docs, style, refactor, test, chore
3. ブランチを作成: `git checkout -b <branch-name>`

## コミットワークフロー

以下に基づいて適切なメッセージでgitコミットを作成:

1. ステージされたファイルとその変更内容
2. リポジトリの過去のコミット履歴パターン

コミット作成時:

- `git diff --cached` でステージされた変更を分析
- `git log` で最近のコミットメッセージを確認し、リポジトリのスタイルに合わせる
- 既存のパターンに従った簡潔で説明的なコミットメッセージを英語で生成
- `git commit -m "message"` を使用
