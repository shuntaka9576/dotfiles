## プルリクエスト作成

以下の手順でGitHubプルリクエストを作成します：

1. 現在のブランチを確認し、必要に応じて作業用ブランチを作成
2. 現在のブランチの状態とコミットされていない変更を確認
3. PRに含まれるすべてのコミットをレビュー
4. 必要に応じてブランチをリモートにプッシュ
5. 適切なタイトルと説明でPRを作成

PR作成時の手順：

- `git branch`で現在のブランチを確認
- `git status`でコミットされていない変更を確認
- `git diff`で変更内容を確認（ブランチ名決定のため）
- **mainブランチの場合**:
  1. 差分を確認して適切なブランチ名を決定
  2. `git checkout -b <prefix>/<branch-name>`でブランチを作成
     - `feat/`: 新機能追加
     - `fix/`: バグ修正
     - `docs/`: ドキュメントのみの変更
     - `refactor/`: リファクタリング
     - `test/`: テストの追加・修正
     - `chore/`: ビルドプロセスや補助ツールの変更
  3. 変更をコミット
- **既に作業用ブランチの場合**: 変更がある場合は適切にコミット
- `git log main..HEAD`でPRに含まれるコミットを確認
- `git diff main...HEAD`ですべての変更内容を把握
- `git push -u origin <branch-name>`でブランチをプッシュ
- 以下のコマンドでDraftのPRを作成し、ブラウザで開く：

  ```bash
  # PR作成コマンドを実行し、URLを変数に保存（自分自身をアサインに設定）
  PR_URL=$(gh pr create --draft --assignee @me)

  # URLからPR番号を抽出（URLの最後の数字部分）
  PR_NUMBER=$(echo $PR_URL | grep -o '[0-9]*$')

  # PRをブラウザで開く
  gh browse $PR_NUMBER
  ```

  以下を含む説明を記載：

  - 変更の概要（1-3個の箇条書き）
  - ファイル/コンポーネント別の詳細な変更リスト
  - テストプランまたはチェックリスト

## PRテンプレート

以下パスのテンプレートファイルの内容を読み込んで、**HTMLコメント（<!-- -->）をエスケープせずにそのまま**PR説明文として使用してください。

**重要**: HTMLコメントの「<」と「!」の間にバックスラッシュを入れないでください。「<!--」を「<\!--」にしないでください。

テンプレートファイル: .github/PULL_REQUEST_TEMPLATE.md

PRテンプレートを使用する際は、Readツールでテンプレートファイルを読み込み、その内容を一時ファイルに書き込んでから以下の手順でDraftのPRを作成してください：

```bash
# PR作成コマンドを実行し、URLを変数に保存（自分自身をアサインに設定）
PR_URL=$(gh pr create --body-file /tmp/pr-body.md --draft --assignee @me)

# URLからPR番号を抽出（URLの最後の数字部分）
PR_NUMBER=$(echo $PR_URL | grep -o '[0-9]*$')

# PRをブラウザで開く
gh browse $PR_NUMBER
```

## 既存のPR説明文を更新する場合

HTMLコメントを保持するため、**必ず一時ファイル経由で更新してください**：

1. PR説明文を一時ファイルに書き込む（例：`/tmp/pr-body-<PR番号>.md`）
2. `gh pr edit <PR番号> --body-file /tmp/pr-body-<PR番号>.md` を実行
3. 一時ファイルを削除（`rm /tmp/pr-body-<PR番号>.md`）

**注意**: heredocや直接の`--body`オプションを使うとHTMLコメントがエスケープされるため、必ず`--body-file`を使用してください。
