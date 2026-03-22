---
name: git-merge-pr
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

### ステップ 3: CI SUCCESSのPRをマージ

CI SUCCESSかつMERGEABLEなPRがある場合、まとめてマージ確認・実行する。

**AskUserQuestion 1回で以下を確認する:**

質問1: マージ対象PR（multiSelect）
- 「全部」を最初の選択肢として含める
- 各PRを個別の選択肢としても提示

質問2: マージ方法
- `--squash`: すべてのコミットを1つにまとめてマージ（推奨）
- `--rebase`: コミットをリベースしてマージ
- `--merge`: マージコミットを作成してマージ

確認後、対象PRそれぞれについてマージ実行する。

```bash
gh pr merge <PR番号> <マージオプション> --delete-branch
```

### ステップ 4: CI FAILUREのPR対応（1PRずつ）

CI FAILUREのPRがない場合はこのステップをスキップしてステップ5へ進む。

各CI FAILUREのPRについて、以下を1つずつ繰り返す。

**1. 失敗詳細の取得**
- `gh pr checks <PR番号>` で失敗しているチェックを特定
- `gh run view <run_id> --log-failed` で失敗ログを取得

**2. 失敗原因と解決策の提示**

```
### CI失敗: PR #<番号>
- 失敗チェック: <チェック名>
- 失敗原因: <ログから読み取った原因の要約>

#### 解決策
- a) <具体的な修正内容の説明> — 修正を実行してCIを再実行
- b) CIの結果を無視してマージする（`--admin`）
- c) このPRをスキップする
```

**3. ユーザー確認後、選択された解決策を実行**
- a) の場合: PRのブランチをチェックアウト → コード修正 → commit → push → CI完了を待機 → マージ実行
- b) の場合: `gh pr merge <PR番号> <マージオプション> --admin --delete-branch` でマージ
- c) の場合: スキップして次のPRへ

完了したら次のCI FAILUREのPRへ進む。

### ステップ 5: 結果報告
全PRの処理結果をまとめて報告する。
- 成功: マージされたPR一覧
- スキップ: マージできなかったPRとその理由
