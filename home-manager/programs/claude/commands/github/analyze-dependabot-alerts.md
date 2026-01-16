# Dependabotアラート解析

## 概要

GitHub Dependabotのセキュリティアラートを1件ずつ解析し、適切な対応を行います。

## リポジトリの取得

現在のディレクトリのリポジトリを自動取得:

```bash
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
```

## 手順

### 1. オープンアラート一覧を取得

以下のコマンドでオープン状態のアラートを取得:

```bash
gh api repos/$REPO/dependabot/alerts --jq '.[] | select(.state == "open") | {number: .number, severity: .security_advisory.severity, package: .security_vulnerability.package.name, summary: .security_advisory.summary}'
```

### 2. 各アラートを1件ずつ解析

ユーザーと確認しながら以下を調査:

1. **依存関係の確認**: `pnpm why <package>` または `npm why <package>` で依存元を特定
2. **使用状況の確認**: 上位ライブラリのコードで該当機能がどう使われているか確認
3. **脆弱性の詳細**: CVE情報や攻撃条件を確認

### 3. 対応方針を決定

対応パターン:

#### a) バージョンアップ

修正版が存在し、アップデート可能な場合:

```bash
pnpm update <package>
# または依存元パッケージのアップデート
```

#### b) dismiss（影響なし / not_used）

脆弱性の条件に該当しない、または該当機能を使用していない場合:

```bash
gh api -X PATCH repos/$REPO/dependabot/alerts/<alert_number> \
  -f state=dismissed \
  -f dismissed_reason=not_used \
  -f dismissed_comment="このプロジェクトでは該当機能を使用していないため"
```

#### c) dismiss（リスク許容 / tolerable_risk）

影響は軽微で対応コストが高い場合:

```bash
gh api -X PATCH repos/$REPO/dependabot/alerts/<alert_number> \
  -f state=dismissed \
  -f dismissed_reason=tolerable_risk \
  -f dismissed_comment="影響が限定的であり、上位ライブラリの対応を待つ"
```

#### d) dismiss（誤検知 / inaccurate）

誤検知の場合:

```bash
gh api -X PATCH repos/$REPO/dependabot/alerts/<alert_number> \
  -f state=dismissed \
  -f dismissed_reason=inaccurate \
  -f dismissed_comment="誤検知: [理由を記載]"
```

### 4. 次のアラートへ

ユーザーに確認し、次のアラートの解析に進む。

## dismissed_reason一覧

| 理由 | 説明 |
|------|------|
| `fix_started` | 修正を開始した |
| `inaccurate` | 誤検知 |
| `no_bandwidth` | 対応するリソースがない |
| `not_used` | 該当機能を使用していない |
| `tolerable_risk` | リスクを許容する |

## 注意事項

- 各アラートは個別に判断し、ユーザーに確認してから対応を実行
- dismissする場合は必ずコメントに理由を記載
- high/criticalの脆弱性は特に慎重に判断
