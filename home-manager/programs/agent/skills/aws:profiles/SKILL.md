---
name: aws:profiles
description: AWS プロファイル一覧の表示
user-invocable: false
---

# AWS プロファイル一覧の表示

## ワークフロー

### ステップ 1: プロファイル一覧取得

以下のスクリプトを実行して、AWS プロファイル情報を取得する:

```bash
~/dotfiles/home-manager/programs/agent/scripts/parse-aws-config.ts
```

### ステップ 2: 一覧表示

JSON 出力の `profiles` 配列からプロファイル一覧をユーザーに表示する。

各プロファイルについて以下の情報を含める:
- プロファイル名
- MFA の要否（`requiresMfa`）
