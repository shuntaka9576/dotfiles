---
name: aws:vault-exec
description: aws-vault exec によるAWS認証
argument-hint: "<profile>"
---

# aws-vault exec によるAWS認証

## 引数

`$ARGUMENTS` として AWS プロファイル名が渡される。

プロファイル名が未指定の場合は、`~/dotfiles/home-manager/programs/agent/scripts/parse-aws-config.ts` を実行してプロファイル一覧を取得し、AskUserQuestion でユーザーにプロファイルを選択させる。

## ワークフロー

### ステップ 1: MFA トークン入力（必要な場合のみ）

まず以下のスクリプトを実行してプロファイル情報を取得する:

```bash
~/dotfiles/home-manager/programs/agent/scripts/parse-aws-config.ts
```

指定されたプロファイルの `requiresMfa` が `true` の場合のみ:
- AskUserQuestion でユーザーに「MFA トークン（6桁の数字）を入力してください」と問い合わせる
- 選択肢は不要（テキスト入力のみ）。options には以下のように MFA デバイスの確認を促す選択肢を提示する:
  - "MFA デバイスを確認して入力します"（ユーザーは "Other" からトークンを直接入力）

### ステップ 2: セッション認証

MFA が必要な場合:
```bash
aws-vault exec <profile> -t <mfa-token> -- aws sts get-caller-identity
```

MFA が不要な場合:
```bash
aws-vault exec <profile> -- aws sts get-caller-identity
```

**注意事項**:
- `aws-vault exec` は子プロセスに AWS 環境変数を自動エクスポートする
- 初回実行時に macOS の keychain パスワードダイアログが表示される場合がある（Bash ツールの実行には影響しない）
- 認証成功するとセッションがキャッシュされる

### ステップ 3: 結果案内

認証成功を確認したら、以下を案内する:

- 認証されたアカウント情報（`get-caller-identity` の結果）を表示
- セッションが確立されたため、以降は通常の AWS CLI コマンドを直接実行できることを説明:
  ```
  aws <command>
  ```
- セッションがキャッシュ済みのため、以降の実行では MFA 入力は不要であることを伝える
