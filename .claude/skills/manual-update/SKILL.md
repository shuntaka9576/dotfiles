---
name: manual-update
description: dotfiles手動アップデート
---

# dotfiles 手動アップデート

## ワークフロー

1. 以下の2つのコマンドを Bash ツールで**並行実行**する（作業ディレクトリ: `~/dotfiles`）
   - `/usr/bin/make`
   - `/usr/bin/make tools`
2. 両方の結果を確認し、成功/失敗を報告する
