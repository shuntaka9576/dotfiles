---
name: gif-compress
description: GIFファイルを圧縮し、プログレスバーを追加する
---

# GIF 圧縮 + プログレスバー追加

## 前提ツール

- `ffmpeg`
- `gifsicle`

## Step 1: 入力ファイルの情報取得

```bash
ffprobe -v quiet -print_format json -show_streams <input.gif>
```

- `width`, `height`, `duration` を取得する

## Step 2: Two-pass エンコード（overlay 方式でプログレスバー追加）

### Pass 1: パレット生成

```bash
ffmpeg -y -i <input.gif> \
  -f lavfi -i "color=c=0x7C3AED:s=<WIDTH>x8:r=10" \
  -filter_complex "[1:v]trim=duration=<DURATION>[bar];[0:v]fps=10[main];[main][bar]overlay=x='min(0,(-<WIDTH>+<WIDTH>*t/<DURATION>))':y=H-8:shortest=1,palettegen=max_colors=128:stats_mode=diff" \
  -update 1 /tmp/palette_gif.png
```

### Pass 2: GIF生成

```bash
ffmpeg -y -i <input.gif> \
  -f lavfi -i "color=c=0x7C3AED:s=<WIDTH>x8:r=10" \
  -i /tmp/palette_gif.png \
  -filter_complex "[1:v]trim=duration=<DURATION>[bar];[0:v]fps=10[main];[main][bar]overlay=x='min(0,(-<WIDTH>+<WIDTH>*t/<DURATION>))':y=H-8:shortest=1[v];[v][2:v]paletteuse=dither=bayer:bayer_scale=3" \
  /tmp/gif_output.gif
```

## Step 3: gifsicle で最適化

```bash
gifsicle -O3 --lossy=80 /tmp/gif_output.gif -o <output.gif>
```

## Step 4: 結果報告

元サイズと圧縮後サイズを比較して報告する。

## パラメータ

| パラメータ | 説明 | デフォルト |
|-----------|------|-----------|
| `<WIDTH>` | 元GIFの横幅（ffprobeで取得） | - |
| `<DURATION>` | 元GIFの再生時間（秒） | - |
| `max_colors` | パレットの最大色数 | 128 |
| `fps` | 出力フレームレート | 10 |
| `--lossy` | gifsicleの非可逆圧縮レベル | 80 |
| バーの色 | プログレスバーの色（hex） | `0x7C3AED`（紫） |
| バーの高さ | プログレスバーのピクセル高 | 8 |

## 注意事項

- プログレスバーが不要な場合は overlay 関連フィルタを除外し `fps=10,palettegen` / `paletteuse` のみで処理する
