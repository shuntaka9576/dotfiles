---
name: codex:plan-review
description: 現在のプランファイルを OpenAI Codex CLI に送ってレビューさせる。プランの問題点・リスク・見落としを検出する。
argument-hint: "<プランファイルのパス（省略時は自動検出）>"
---

# Codex Plan Review

## 概要
Claude Code が作成したプランを Codex CLI でレビューし、セカンドオピニオンを得る。

## ワークフロー

1. プランファイルを特定する
   - 引数で指定されていればそのパスを使う
   - 未指定の場合、以下の順に自動検出する
     a. `~/.config/claude/plans/` 配下の最新の `.md` ファイル
     b. カレントディレクトリの `PLAN.md` or `plan.md`
2. プランファイルの内容を読み取る
3. `codex exec` でレビューを実行する
4. レビュー結果をユーザーに表示する

## Codex 実行コマンド

```bash
codex exec --dangerously-bypass-approvals-and-sandbox \
  "You are reviewing a plan created by Claude Code. Analyze it for:

1. Potential issues or risks
2. Missing steps or considerations
3. Better alternatives (if any)
4. Edge cases not addressed
5. Security concerns

Be concise. Only flag significant concerns. Respond in the same language as the plan.

PLAN:
<プランファイルの内容をここに展開>

Respond with:
- VERDICT: LGTM (if the plan is solid) or VERDICT: NEEDS REVISION
- Specific concerns as bullet points (max 5)
- Suggested improvements (if any)"
```

## 注意事項
- codex CLI が PATH に存在しない場合はエラーメッセージを表示して終了すること
- プランファイルが見つからない場合も同様
- タイムアウトは120秒を目安とする
- Codex のレスポンスはそのままユーザーに表示する（加工しない）

## ARGUMENTS
{{ARGUMENTS}}
