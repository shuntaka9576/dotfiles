---
name: git-create-pr
description: プルリクエスト作成
argument-hint: "<ベースブランチ名（省略可）>"
---

# プルリクエスト作成

## ワークフロー

### ステップ 1: ベースブランチ決定
- 引数でブランチ名が指定されていればそれをベースブランチとして使用
- 指定がなければデフォルトブランチ（`main` or `master`）を使用

### ステップ 2: 言語選択
ユーザーに確認: 「PRを日本語で作成しますか、英語で作成しますか？（日本語/英語）」

### ステップ 3: 状態確認
1. 現在のブランチを確認: `git branch --show-current`
2. **ベースブランチと同じ場合**: ユーザーに確認「ベースブランチです。ブランチを作成してコミットしますか？（はい/いいえ）」
   - はい → `/git-commit` スキルを実行
   - いいえ → 処理を中断
3. コミット状況を確認: `git log <ベースブランチ>..HEAD`
4. 変更内容を確認: `git diff <ベースブランチ>...HEAD`

### ステップ 4: プッシュ
1. `git push -u origin <branch-name>` でリモートにプッシュ

### ステップ 5: PR 作成
1. PRテンプレート（`.github/PULL_REQUEST_TEMPLATE.md`）があれば読み込む
2. 選択された言語でタイトル・説明を作成
3. 以下のコマンドで Draft PR を作成:

```bash
# PR作成コマンドを実行し、URLを変数に保存（自分自身をアサインに設定）
# ベースブランチが指定されている場合は --base <ベースブランチ> を付与
PR_URL=$(gh pr create --draft --assignee @me --base <ベースブランチ>)

# URLからPR番号を抽出（URLの最後の数字部分）
PR_NUMBER=$(echo $PR_URL | grep -o '[0-9]*$')

# PRをブラウザで開く
gh browse $PR_NUMBER
```

## PR説明の内容

以下を含む説明を記載:
- 変更の概要（1-3個の箇条書き）
- ファイル/コンポーネント別の詳細な変更リスト
- テストプランまたはチェックリスト

## PRテンプレート使用時

テンプレートファイル: `.github/PULL_REQUEST_TEMPLATE.md`

**重要**: HTMLコメント（`<!-- -->`）をエスケープせずにそのまま使用。「`<!--`」を「`<\!--`」にしない。

PRテンプレートを使用する際は、Readツールでテンプレートファイルを読み込み、内容を一時ファイルに書き込んでから作成:

```bash
# ユニークな一時ファイル名を生成
TEMP_FILE="/tmp/pr-body-$(date +%s).md"

# PR作成コマンドを実行し、URLを変数に保存（自分自身をアサインに設定）
# ベースブランチが指定されている場合は --base <ベースブランチ> を付与
PR_URL=$(gh pr create --body-file "$TEMP_FILE" --draft --assignee @me --base <ベースブランチ>)

# URLからPR番号を抽出（URLの最後の数字部分）
PR_NUMBER=$(echo $PR_URL | grep -o '[0-9]*$')

# 一時ファイルを削除
rm -f "$TEMP_FILE"

# PRをブラウザで開く
gh browse $PR_NUMBER
```

## 既存のPR説明文を更新する場合

HTMLコメントを保持するため、**必ず一時ファイル経由で更新**:

```bash
# ユニークな一時ファイル名を生成
TEMP_FILE="/tmp/pr-body-<PR番号>-$(date +%s).md"

# PR説明文を一時ファイルに書き込む（Writeツールを使用）
# gh pr edit を実行
gh pr edit <PR番号> --body-file "$TEMP_FILE"

# 一時ファイルを削除
rm -f "$TEMP_FILE"
```

**注意**: heredocや直接の`--body`オプションを使うとHTMLコメントがエスケープされるため、必ず`--body-file`を使用。
