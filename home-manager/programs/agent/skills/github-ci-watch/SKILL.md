---
name: github-ci-watch
description: CI監視 & Draft PR Ready化。PRのCIチェックを監視し、成功したらDraft PRをReadyにする。CI失敗時はログを分析してコードと紐付けた修正提案を行う。CIを見ておいて、CI待って、PR ready にして、のような依頼で使用する。
argument-hint: "<PR番号（省略可）>"
---

# CI監視 & Draft PR Ready化

## 注意事項
- Bashツール実行時の description は日本語で簡潔に書くこと（例: "CIチェック状態を取得"）
- `/git-create-pr` で作成したDraft PRに対して使用可能

## ワークフロー

### ステップ 1: PR特定
1. 引数でPR番号が指定されている場合はそれを使用
2. 指定がなければ現在のブランチから検出:

```bash
gh pr view --json number,title,state,isDraft
```

3. バリデーション:
   - PRが存在しない → 「PRが見つかりません。`/git-create-pr` で作成してください」と報告して終了
   - Draftでない → 「このPRは既にReadyです」と報告して終了
   - Closed/Merged → 報告して終了

### ステップ 2: CI状態確認 & 待機

まず現在のチェック状態を確認:

```bash
gh pr checks <PR番号>
```

- 全チェックが既にSUCCESSの場合 → ステップ4へスキップ
- 全チェックが既にFAILの場合 → ステップ3へ
- PENDING/IN_PROGRESSの場合 → 以下で待機:

```bash
gh pr checks <PR番号> --watch
```

- Bashツールのtimeoutは600000ms（10分）に設定する
- タイムアウトした場合: 現在の状態を報告し、AskUserQuestionで確認
  - 「CIがまだ実行中です。継続して待機しますか？」
  - はい → 再度 `--watch` を実行
  - いいえ → 中断

### ステップ 3: CI失敗時の分析と修正提案

**1. 失敗チェックの特定**

```bash
gh pr checks <PR番号>
```

失敗しているチェックを特定する。

**2. 失敗ログの取得**

```bash
gh run view <run_id> --log-failed
```

失敗したworkflow runのログを取得する。

**3. 失敗原因の分析**
- ログからエラーメッセージ・スタックトレースを読み取る
- エラーに関連するファイル・行番号を特定する

**4. コードとの紐付け**
- PRのdiffを取得: `gh pr diff <PR番号>`
- エラーに関連するソースコードをReadツールで読み込む
- PR変更箇所と失敗原因の関連性を分析する

**5. 修正提案の提示**

以下の形式でユーザーに提示する:

```
## CI失敗分析: PR #<番号> - <タイトル>

### 失敗チェック
- <チェック名>: <失敗原因の要約>

### 関連コード
- `<ファイルパス>:<行番号>` — <該当箇所の説明>

### 修正提案
- <具体的な修正内容の説明>
```

**6. 対応の確認**

AskUserQuestionで対応方法を確認:
- a) 修正を実行する → コード修正 → commit → push → ステップ2に戻って再監視
- b) 失敗を無視してReadyにする → ステップ4へ
- c) 中断する

### ステップ 4: Ready化

AskUserQuestionでユーザーに確認:
- 「CIが全てパスしました。PRをReadyにしますか？」
- はい → 以下を実行:

```bash
gh pr ready <PR番号>
```

- いいえ → Draftのまま終了

### ステップ 5: 結果報告

最終結果をまとめて報告する:

```
## 結果
- PR: #<番号> <タイトル>
- CI: SUCCESS / FAILURE
- 状態: Ready / Draft
```
