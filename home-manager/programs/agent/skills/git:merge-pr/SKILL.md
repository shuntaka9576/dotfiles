---
name: git:merge-pr
description: PRマージ
---

# PRマージ

## ワークフロー

### ステップ 1: PR特定
1. 引数でPR番号が指定されている場合はそれを使用（複数指定可）
2. 引数がなければ、現在のブランチに紐づくPRを自動取得: `gh pr view --json number,title,state`
   - PRが1件見つかればそれを使用
3. PRが見つからない、または複数PRの候補から選びたい場合は、オープンなPR一覧を取得: `gh pr list --json number,title,headRefName,author --limit 20`
   - 一覧をユーザーに提示し、AskUserQuestion でマージ対象を選択してもらう（複数選択可）

### ステップ 2: マージオプション確認
AskUserQuestion ツールを使い、以下の2点をユーザーに確認する。全PRに共通で適用する。

**質問1: CIの状態確認**
- CIの完了を待ってからマージする
- CIの結果を無視してマージする（`--admin`）

**質問2: マージ方法**
- `--squash`: すべてのコミットを1つにまとめてマージ
- `--rebase`: コミットをリベースしてマージ
- `--merge`: マージコミットを作成してマージ

### ステップ 3: マージ実行（対象PRごとに繰り返す）
対象PRそれぞれについて以下を実行する。

1. PRの状態を確認: `gh pr view <PR番号> --json title,state,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup`
2. マージ可能でない場合はスキップし、理由を記録して次のPRへ進む
3. マージ実行:

```bash
gh pr merge <PR番号> <マージオプション> --delete-branch
```

### ステップ 4: 結果報告
全PRの処理結果をまとめて報告する。
- 成功: マージされたPR一覧
- スキップ: マージできなかったPRとその理由
