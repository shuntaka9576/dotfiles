---
name: it-news-digest
description: 海外ITニュースの調査・ダイジェスト作成。Hacker News / TechCrunch / The Verge に加え、Anthropic / Cloudflare / Tailscale 等のテックブログから最新記事を取得し、日本語で要約する。
user-invocable: true
argument-hint: "<トピック/キーワード（省略可）>"
---

海外ITニュースダイジェストを作成し、GitHubリポジトリにコミット＆プッシュしてください。以下の手順で完全自律で実行すること。

## ステップ0: リポジトリ準備

1. `git clone https://github.com/shuntaka9576/daily-news.git` でリポジトリをクローン
2. クローンしたディレクトリに移動

## ステップ1: ヘッドライン収集（6ソース）

以下の6ソースからWebFetchでヘッドラインを取得する。

### ニュースサイト

#### Hacker News
- WebFetch で https://news.ycombinator.com を取得
- 上位30件の記事タイトル・URL・ポイント数を抽出

#### TechCrunch
- WebFetch で https://techcrunch.com を取得
- トップページの記事タイトル・URLを最大15件抽出

#### The Verge
- WebFetch で https://www.theverge.com を取得
- トップページの記事タイトル・URLを最大15件抽出

### テックブログ

#### Anthropic Blog
- WebFetch で https://www.anthropic.com/news を取得
- 最新記事のタイトル・URL・日付を最大10件抽出
- AI/LLM関連の新機能・研究・安全性に関する記事に注目

#### Cloudflare Blog
- WebFetch で https://blog.cloudflare.com を取得
- 最新記事のタイトル・URL・日付を最大10件抽出
- インフラ・セキュリティ・エッジコンピューティング関連の記事に注目

#### Tailscale Blog
- WebFetch で https://tailscale.com/blog を取得
- 最新記事のタイトル・URL・日付を最大10件抽出
- ネットワーキング・VPN・ゼロトラスト関連の記事に注目

## ステップ2: 注目記事の選定（各ソース最大5件）

各ソースから最大5件ずつ注目記事を選定する（合計最大30件）。以下の基準で選定すること。

選定基準（優先度順）:
1. 鮮度最優先: 直近数時間〜当日の記事を優先
2. 注目度: HN 100ポイント以上、TechCrunch/The Verge のトップ掲載、テックブログの新着記事を優先
3. IT/テクノロジー関連: 技術・プロダクト・業界動向に関する記事を優先。政治・文化のみの記事は除外
4. 重複統合: 複数ソースで同じ話題が出ている場合は1件に統合し、ソースを併記

## ステップ3: 各記事の本文取得・要約

選定した各記事について:
1. WebFetch で記事ページの本文を取得
2. 取得した本文をもとに日本語で要約を作成:
   - 概要: 2〜3文で何が起きたかを説明
   - ポイント: なぜ重要か、業界やエンジニアへの影響
   - 技術的な学び: エンジニアとして知っておくべき技術的ポイント（該当する記事のみ）

## ステップ4: ファイル作成・コミット・プッシュ

1. 現在のJST日時を取得する（`TZ=Asia/Tokyo date +%Y%m%d-%H%M`）
2. その日時をファイル名にして Markdown ファイルを作成する
   - ファイル名例: `20260329-0530.md`
3. ファイルの内容は以下の形式:

```
## 海外ITニュースダイジェスト（YYYY-MM-DD）

### 1. 記事タイトル
**ソース**: Hacker News (xxx points) / TechCrunch / The Verge / Anthropic Blog / Cloudflare Blog / Tailscale Blog
**URL**: https://...

**概要**: ...

**ポイント**: ...

**技術的な学び**: ...

---

### 2. 記事タイトル
...
```

末尾に「その他の注目ヘッドライン」としてタイトル+URLのみの一覧を簡潔に付記する。

4. git add, git commit, git push を実行してリポジトリにプッシュする
   - コミットメッセージ: `docs: YYYYMMDD-HHmm IT news digest`

## 注意事項
- 対話は一切行わず、完全自律で実行すること
- WebFetchで取得できない場合はWebSearchで代替すること
- 全て日本語で出力すること
- 必ずリポジトリにコミット＆プッシュすること
