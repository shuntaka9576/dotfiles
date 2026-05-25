---
name: codex-image-gen
description: "画像・ビジュアル素材を新規生成したいあらゆる依頼で発動する。Codex CLI 組み込みの image_gen（gpt-image-2）を呼び、API キー無しで ChatGPT サブスクから PNG をカレントディレクトリに吐き出す、Claude Code 唯一の画像生成手段。対象例: ロゴ・アイコン・ファビコン・SVG 用ラフ、スライドや登壇資料の表紙/ヘッダー/章扉、ブログやドキュメントのアイキャッチ・OGP・サムネ、バナー・ヒーロー画像・背景イラスト、抽象的な「テック感」「ビジネス感」のイメージビジュアル、キャラ絵・コンセプトアート、SNS 投稿画像、モックアップ用ダミー写真など。「画像/イラスト/絵/ビジュアル/写真/イメージを作って・生成して・描いて・出して」「ロゴ/アイコン/サムネ/バナー/表紙/カバー/ヘッダーを作って」「1920x1080 で」「正方形で」のようなサイズ指定や、「Codex/OpenAI/gpt-image/DALL-E で」など特定エンジン指定も全部拾う。ユーザーが画像を新しく作ってほしそうな意図を見せたら、スキル名や Codex への言及が無くても積極的に発動。既存画像の編集・解析・トリミング・OCR は対象外。"
user-invocable: true
argument-hint: "<画像プロンプト>"
---

# Codex 画像生成

Claude Code から Codex CLI 組み込みの image_gen ツール（gpt-image-2）を呼んで画像を生成し、カレントディレクトリに保存する。

## なぜこのスキルがあるか

通常、画像生成 API を叩くには OpenAI API キーとスクリプトが必要。しかし Codex CLI には ChatGPT 認証で使える組み込み image_gen ツールが入っており、`codex exec` のプロンプトに「組み込みの image_gen ツールを直接呼んで」と指示するだけで、API キー無しで画像が生成できる。サブスク利用なら追加課金もない。本スキルはこの呼び出し手順とよくあるハマりどころを定型化する。

## 前提ツール

- `codex` CLI（`codex login` 済み）
- `jq`（`~/.codex/auth.json` の判定に使用、無ければ grep フォールバック）

## Step 0: 入力プロンプトの確認

引数 `$ARGUMENTS` をユーザープロンプトとして使う。引数が空、または被写体・シーン・スタイルのいずれも欠けていてモデルが情景を描きようがない極端に貧弱な指示の場合は、AskUserQuestion で「どんな画像を生成したいか（被写体・スタイル・雰囲気など）」を確認する。固有名詞 1 語だけ、のような場合は再質問する。

## Step 1: codex CLI 可用性チェック

```bash
command -v codex >/dev/null && codex --version
```

失敗したら `mise install` か `npm i -g @openai/codex` を案内して中断する。

## Step 2: 認証モードと課金確認

`~/.codex/auth.json` の中身で課金体系が変わるので、実行前に判定する。

```bash
mode=$(jq -r '
  if (.OPENAI_API_KEY // "") != "" then "api_key"
  elif (.tokens // null) != null then "chatgpt"
  else "unknown"
  end
' ~/.codex/auth.json 2>/dev/null)
echo "$mode"
```

`jq` が無い場合のフォールバック:

```bash
if grep -q '"OPENAI_API_KEY"[[:space:]]*:[[:space:]]*"[^"]\+"' ~/.codex/auth.json; then
  mode=api_key
elif grep -q '"tokens"' ~/.codex/auth.json; then
  mode=chatgpt
else
  mode=unknown
fi
```

分岐:

- `chatgpt` → ChatGPT サブスク内で実行される旨を 1 行報告し、そのまま続行
- `api_key` → AskUserQuestion で「OpenAI API の従量課金が発生します。続行しますか?」を確認。No なら中断
- `unknown` または `auth.json` が無い → `codex login` を案内して中断

ChatGPT モードを無確認で進めるのは、サブスク内で追加課金が発生しないため。`api_key` モードは 1 枚あたり数セント単位で課金されるので、ユーザーの意思を確かめる。

## Step 3: 出力先パスと開始時刻の記録

Codex は `~/.codex/generated_images/<session-id>/` に画像を吐く。Step 4 後にこの中から「Step 3 以降に作られた」ファイルだけ拾うため、開始時刻を控える。

```bash
OUTPUT="$(pwd)/codex-image-$(date +%Y%m%d-%H%M%S).png"
START_TS=$(date +%s)
```

## Step 4: codex exec で生成

`codex exec` のプロンプトに「組み込みの image_gen ツールを直接呼べ」「API キーやスクリプトは書くな」と書くのが極めて重要。これを書かないと、Codex は OpenAI API を叩く Python スクリプトを書き始めて API キーを要求してしまう。

ヒアドキュメント `<<'EOF'` だと変数展開が効かないので、プロンプトはシェル変数に組み立ててから `codex exec` に渡す。

```bash
USER_PROMPT="<Step 0 で確定したプロンプト>"
FULL_PROMPT="Codex 組み込みの image_gen ツール（gpt-image-2）を直接呼び出して、以下の指示で画像を1枚だけ生成してください。

重要な制約:
- API キーやスクリプトは書かない。組み込みの image_gen ツールのみを使用する
- サイズ: 各辺は 16 の倍数、最大 3840px、アスペクト比 3:1 以下
- 形式: PNG（透過背景は不可）

指示:
${USER_PROMPT}"

codex exec --dangerously-bypass-approvals-and-sandbox --cd "$PWD" "$FULL_PROMPT"
```

`--dangerously-bypass-approvals-and-sandbox` はサンドボックスを外すフラグ。デフォルトの Codex サンドボックスはネットワークをブロックするので、画像生成 API に到達するためには必須。

### 長時間実行の扱い

`codex exec` は数十秒〜数分かかる。Claude Code 側からは Bash の `run_in_background: true` で投げ、`BashOutput` でポーリングするのが望ましい。標準出力に「Generated image saved to ...」のような行が出れば成功。

`exit code` が 0 以外なら stderr/stdout の末尾を要約してユーザーに見せて中断する（rate limit、ネットワーク切断、認証切れなど）。

## Step 5: 生成物をカレントへコピー

`~/.codex/generated_images/` 配下から Step 3 の `START_TS` 以降に作成された最新の画像を 1 枚拾う。

```bash
SRC=$(find ~/.codex/generated_images -type f \( -name '*.png' -o -name '*.jpg' \) -newermt "@$START_TS" -print0 \
  | xargs -0 ls -t 2>/dev/null \
  | head -1)

if [ -z "$SRC" ]; then
  echo "Codex が画像を出力しませんでした。codex exec の出力を確認してください。"
  exit 1
fi

cp "$SRC" "$OUTPUT"
file "$OUTPUT"
```

`SRC` が空のときは Codex 側でツール呼び出しが失敗したか、プロンプトが拒否された可能性。`codex exec` の出力にエラー要因があるはずなので、それをユーザーに見せる。

## Step 6: 結果報告

3 行程度でユーザーに報告:

- 出力先絶対パス（`$OUTPUT`）
- `file "$OUTPUT"` の dimensions / フォーマット
- `ls -lh "$OUTPUT"` のファイルサイズ

## トラブルシューティング

- **rate limit / 4xx エラー**: サブスク側で 1 時間あたりの生成上限がある。少し待って再実行する。それでも失敗するならサイズ要件違反の可能性が高いので、プロンプトに「1024x1024 で出力」のような具体的サイズを足して再試行
- **生成スタイルが想像と違う**: プロンプトに `style: cinematic photography` / `lighting: golden hour` / `medium: oil painting` のような指定を追加して再実行
- **空ファイル / 中途半端なファイル**: `codex exec` がタイムアウトした可能性。`--cd "$PWD"` を維持したまま再実行する

## 注意事項

- `--dangerously-bypass-approvals-and-sandbox` は画像生成 API のネットワーク到達のために必須。本スキル以外で安易に流用しない
- アスペクト比 3:1 を超えるリクエストは API 側で 4xx になるため、極端なパノラマ依頼は避ける
- 透過背景（transparent）は gpt-image-2 では非対応。透過が必要な場合は別ツールを使う
- `~/.codex/generated_images/` の元画像は Codex 側のセッション管理に従って残る。本スキルではクリーンアップしない
