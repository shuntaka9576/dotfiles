# Manjaro

```{toctree}
:maxdepth: 1
:caption: architecture
```

## 環境構築

```bash
cd ./nix
./install.sh
```

nix経由だと正常に動作しないケース(GPU周り)があるため、pacman経由で導入する

```bash
pacman -S wezterm
pacman -S alacritty
```
