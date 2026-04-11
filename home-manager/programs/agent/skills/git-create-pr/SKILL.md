---
name: git-create-pr
description: プルリクエスト作成
argument-hint: ""
---

# プルリクエスト作成

## 注意事項
- Bashツール実行時の description は日本語で簡潔に書くこと
- **ベースブランチ（main/master）への直接プッシュは絶対に禁止。** ステップ4のガードレールを必ず通過すること

## ワークフロー

### ステップ 1: ベースブランチ決定
- デフォルトブランチ（`main` or `master`）をデフォルト値とする
- AskUserQuestion でユーザーに確認: 「ベースブランチはどれにしますか？」（デフォルト値を提示）

### ステップ 2: 言語選択

AskUserQuestion でユーザーに確認: 「PRを日本語で作成しますか、英語で作成しますか？」（選択肢: 日本語 / 英語）

### ステップ 3: 状態確認

1. 現在のブランチを確認: `git branch --show-current`

2. **ベースブランチと同じ場合:**
   - AskUserQuestion でユーザーに確認: 「現在ベースブランチ上にいます。新しいブランチを作成してコミットしますか？」（選択肢: はい / いいえ）
   - **いいえ** → 「ベースブランチに直接プッシュはできません。処理を中断します」と報告して終了
   - **はい** → `/git-git-commit` スキルを実行（このスキル内でブランチ作成が行われる）
   - `/git-git-commit` 完了後、再度 `git branch --show-current` でブランチを確認
   - **まだベースブランチ上にいる場合 → 処理を中断する（絶対にプッシュしない）**

3. **コミット状況と差分の確認:**

   リモートの最新ベースブランチを取得してから差分を確認する。これにより、スカッシュマージ済みブランチを再利用した場合でも、新規変更分のみが正しく表示される。

   ```bash
   git fetch origin <ベースブランチ>
   git log origin/<ベースブランチ>..HEAD --oneline
   git diff origin/<ベースブランチ> HEAD
   ```

4. コミットが0件の場合: 「コミットがありません。先にコミットしてください」と報告して終了

### ステップ 4: プッシュ（ベースブランチ保護ガード付き）

1. **再度ブランチを確認**: `git branch --show-current`
2. **ベースブランチ（main/master）でないことを必ず確認する**
   - ベースブランチの場合 → **絶対にプッシュせず、エラーメッセージを表示して処理を中断する**
3. `git push -u origin <現在のブランチ名>` でリモートにプッシュ

### ステップ 5: PR 作成
1. PRテンプレート（`.github/PULL_REQUEST_TEMPLATE.md`）があれば読み込む
2. 選択された言語でタイトル・説明を作成
3. 以下のコマンドで Draft PR を作成:

```bash
PR_URL=$(gh pr create --draft --assignee @me --base <ベースブランチ>)
PR_NUMBER=$(echo $PR_URL | grep -o '[0-9]*$')
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
TEMP_FILE="/tmp/pr-body-$(date +%s).md"
PR_URL=$(gh pr create --body-file "$TEMP_FILE" --draft --assignee @me --base <ベースブランチ>)
PR_NUMBER=$(echo $PR_URL | grep -o '[0-9]*$')
rm -f "$TEMP_FILE"
gh browse $PR_NUMBER
```

## 既存のPR説明文を更新する場合

HTMLコメントを保持するため、**必ず一時ファイル経由で更新**:

```bash
TEMP_FILE="/tmp/pr-body-<PR番号>-$(date +%s).md"
gh pr edit <PR番号> --body-file "$TEMP_FILE"
rm -f "$TEMP_FILE"
```

**注意**: heredocや直接の`--body`オプションを使うとHTMLコメントがエスケープされるため、必ず`--body-file`を使用。
