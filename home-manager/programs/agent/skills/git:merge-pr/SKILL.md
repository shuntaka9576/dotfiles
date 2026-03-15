---
name: git:merge-pr
description: PRマージ
---

# PRマージ

## 注意事項
- Bashツール実行時の description は日本語で簡潔に書くこと（例: "オープンPR一覧を取得"）

## ワークフロー

### ステップ 1: PR特定
1. 引数でPR番号が指定されている場合はそれを使用（複数指定可）
2. 引数がなければ、オープンなPR一覧を取得: `gh pr list --json number,title,headRefName,author --limit 20`

### ステップ 2: PR詳細取得 + 情報提示

**全PRの詳細を並列で取得する:**
- `gh pr view <PR番号> --json title,state,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup`
- `gh pr diff <PR番号>`

**重要: 各PRの変更内容とマージ可能性を必ずユーザーに見せること。** diffを読み解き、以下の形式でPRごとに提示する。

**PRごとの提示内容:**

```
## PR #<番号>: <タイトル>
- CI: SUCCESS / PENDING / FAILURE
- マージ可能性: MERGEABLE / UNKNOWN / CONFLICTING

### 変更内容
<diffから読み取った具体的な変更内容を箇条書きで記載>
```

変更内容の記載ルール:
- パッケージ更新: パッケージ名と旧バージョン → 新バージョンを明示（例: `typescript: 5.3.0 → 5.4.0`）
- コード変更: 変更ファイルと変更の概要を具体的に記載
- 設定変更: 変更されたキーと値を明示

### ステップ 3: 一括確認

**AskUserQuestion 1回で以下をまとめて確認する:**

質問1: マージ対象PR（multiSelect）
- 「全部」を最初の選択肢として含める
- 各PRを個別の選択肢としても提示

質問2: マージ方法
- `--squash`: すべてのコミットを1つにまとめてマージ（推奨）
- `--rebase`: コミットをリベースしてマージ
- `--merge`: マージコミットを作成してマージ

質問3: CI状態の扱い（CI未完了・失敗のPRがある場合のみ表示）
- CIの結果を無視してマージする（`--admin`）
- CI未完了のPRはスキップする

### ステップ 4: マージ実行（対象PRごとに繰り返す）
対象PRそれぞれについて以下を実行する。

1. マージ可能でない場合はスキップし、理由を記録して次のPRへ進む
2. マージ実行:

```bash
gh pr merge <PR番号> <マージオプション> --delete-branch
```

### ステップ 5: 結果報告
全PRの処理結果をまとめて報告する。
- 成功: マージされたPR一覧
- スキップ: マージできなかったPRとその理由
