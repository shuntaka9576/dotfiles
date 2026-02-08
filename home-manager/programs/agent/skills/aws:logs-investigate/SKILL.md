---
name: aws:logs-investigate
description: CloudWatch Logs の調査・分析。ログの検索、フィルタリング、Insights クエリの実行を行い、結果を要約して返す。
context: fork
agent: general-purpose
argument-hint: "<profile>"
---

# CloudWatch Logs 調査

## 重要: 出力量の制御

**全ての AWS CLI コマンドに `--query` (JMESPath) オプションを付与し、出力を最小限に絞ること。**
これはコンテキストウィンドウの溢れを防ぐための必須ルールである。

`--query` を使わずに全フィールドを取得することは禁止。必ず必要なフィールドのみを抽出する。

また、`--max-items` や `--limit` が使えるコマンドでは積極的に使用し、取得件数を制限する。

## 重要: aws-vault 経由での実行

全ての `aws` コマンドは **必ず `aws-vault exec <profile> --` を前置して実行すること**。

```bash
# 正しい例
aws-vault exec <profile> -- aws logs describe-log-groups ...

# 間違った例（直接実行は禁止）
aws logs describe-log-groups ...
```

## 引数

`$ARGUMENTS` として AWS プロファイル名が渡される。

プロファイル名が未指定の場合は、`~/dotfiles/home-manager/programs/agent/scripts/parse-aws-config.ts` を実行してプロファイル一覧を取得し、AskUserQuestion でユーザーにプロファイルを選択させる。

## ワークフロー

### ステップ 1: 認証確認

```bash
aws-vault exec <profile> -- aws sts get-caller-identity --query '{Account:Account,Arn:Arn}' --output table
```

認証エラーの場合は、`/aws:vault-exec` でセッションを確立する必要がある旨を案内して終了する。

### ステップ 2: ロググループの選択

ロググループ一覧を取得する:

```bash
aws-vault exec <profile> -- aws logs describe-log-groups \
  --query 'logGroups[].{name:logGroupName,storedBytes:storedBytes,retentionDays:retentionInDays}' \
  --output table \
  --max-items 30
```

取得したロググループ名を **AskUserQuestion** で提示し、ユーザーにどのロググループを調査するか選択させる。

ロググループが多い場合はプレフィックスを聞いて `--log-group-name-prefix` で絞り込む。

### ステップ 3: 調査方針の選択

**AskUserQuestion** で調査方法を選択させる:

- **パターン検索** (`filter-log-events`): 特定の文字列やパターンでログを検索
- **Insights クエリ** (`start-query`): 集計・統計が必要な複雑な分析
- **tail** (`tail`): 直近のログをリアルタイムに確認
- **特定ストリーム** (`get-log-events`): 特定のログストリームの詳細確認

選択後、必要に応じて検索パターンや時間範囲を AskUserQuestion で確認する。

### ステップ 4: ログの調査

選択された方法で調査を実行する。

#### 方法 A: filter-log-events (パターン検索)

```bash
aws-vault exec <profile> -- aws logs filter-log-events \
  --log-group-name "<log-group>" \
  --filter-pattern "<pattern>" \
  --start-time <epoch-ms> \
  --end-time <epoch-ms> \
  --query 'events[:20].{timestamp:timestamp,message:message}' \
  --output table \
  --max-items 20
```

**フィルタパターンの構文:**
- 文字列検索: `"ERROR"` / `"Exception"`
- JSON フィールド検索: `{ $.level = "ERROR" }`
- 複合条件: `{ $.statusCode = 500 && $.duration > 1000 }`

#### 方法 B: CloudWatch Logs Insights (複雑な分析)

```bash
# クエリ開始
QUERY_ID=$(aws-vault exec <profile> -- aws logs start-query \
  --log-group-name "<log-group>" \
  --start-time <epoch> \
  --end-time <epoch> \
  --query-string 'fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 20' \
  --query 'queryId' \
  --output text)

# 数秒待機
sleep 3

# 結果取得
aws-vault exec <profile> -- aws logs get-query-results \
  --query-id "$QUERY_ID" \
  --query '{status:status,results:results[:20]}'
```

**よく使う Insights クエリ:**
- エラー集計: `stats count(*) by @message | filter @message like /ERROR/ | sort count desc | limit 10`
- レイテンシ分析: `stats avg(duration), max(duration), p99(duration) by bin(5m)`
- エラー率推移: `stats count(*) as total, sum(@message like /ERROR/) as errors by bin(1h)`

#### 方法 C: tail (直近のログ確認)

```bash
aws-vault exec <profile> -- aws logs tail "<log-group>" \
  --since 5m \
  --format short
```

**注意**: `--follow` フラグは使用しないこと（プロセスが終了しないため）。

#### 方法 D: get-log-events (特定ストリームの詳細確認)

まずストリーム一覧を取得:

```bash
aws-vault exec <profile> -- aws logs describe-log-streams \
  --log-group-name "<log-group>" \
  --order-by LastEventTime \
  --descending \
  --query 'logStreams[:10].{name:logStreamName,lastEvent:lastEventTimestamp}' \
  --output table \
  --max-items 10
```

AskUserQuestion でストリームを選択させた後:

```bash
aws-vault exec <profile> -- aws logs get-log-events \
  --log-group-name "<log-group>" \
  --log-stream-name "<stream>" \
  --start-time <epoch-ms> \
  --query 'events[:20].{timestamp:timestamp,message:message}' \
  --output table \
  --limit 20
```

### ステップ 5: 結果の要約

調査が完了したら、以下の形式で要約を返すこと:

1. **調査対象**: ロググループ名、期間
2. **検索条件**: 使用したフィルタパターンやクエリ
3. **主要な発見**: エラーの内容、発生頻度、パターン
4. **推奨アクション**: 次に取るべき対応（あれば）

要約は簡潔に、メインコンテキストで理解できる粒度で記述する。

追加の調査が必要な場合は、AskUserQuestion でユーザーに確認してからステップ 3 に戻る。

## `--query` JMESPath パターン集

### ロググループ
```
'logGroups[].{name:logGroupName,stored:storedBytes,retention:retentionInDays}'
'logGroups[?contains(logGroupName,`keyword`)].logGroupName'
```

### ログストリーム
```
'logStreams[:N].{name:logStreamName,lastEvent:lastEventTimestamp}'
'logStreams[?lastEventTimestamp>`EPOCH`].logStreamName'
```

### ログイベント
```
'events[:N].{ts:timestamp,msg:message}'
'events[?contains(message,`ERROR`)].message'
'length(events[])'
```

### Insights 結果
```
'{status:status,count:length(results),results:results[:N]}'
'results[].[field, value]'
```

## 時刻指定のヘルパー

多くのコマンドで epoch ミリ秒が必要。以下で変換:

```bash
# 現在から1時間前(ミリ秒)
echo $(($(date +%s) * 1000 - 3600000))

# 現在時刻(ミリ秒)
echo $(($(date +%s) * 1000))

# 特定日時を epoch 秒に変換(macOS)
date -j -f "%Y-%m-%d %H:%M:%S" "2025-01-15 10:00:00" +%s

# start-query 用の epoch 秒(ミリ秒ではない)
echo $(date +%s)
```
