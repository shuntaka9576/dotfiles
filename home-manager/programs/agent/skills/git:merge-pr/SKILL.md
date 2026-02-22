---
name: git:merge-pr
description: PRマージ
---

# PRマージ

## ワークフロー

### ステップ 1: PR特定
1. 引数でPR番号が指定されていればそれを使用
2. 指定がなければ現在のブランチに紐づくPRを取得: `gh pr view --json number,title,state`
3. PRが見つからない場合は処理を中断

### ステップ 2: PR状態確認
1. PRの状態を確認: `gh pr view <PR番号> --json title,state,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup`
2. マージ可能でない場合はユーザーに報告して中断

### ステップ 3: ユーザー確認
AskUserQuestion ツールを使い、以下の2点をユーザーに確認する。

**質問1: CIの状態確認**
- CIの完了を待ってからマージする
- CIの結果を無視してマージする（`--admin`）

**質問2: マージ方法**
- `--squash`: すべてのコミットを1つにまとめてマージ
- `--rebase`: コミットをリベースしてマージ
- `--merge`: マージコミットを作成してマージ

### ステップ 4: マージ実行
1. 選択されたマージ方法で実行:

```bash
gh pr merge <PR番号> <マージオプション> --delete-branch
```

2. マージ結果を報告
