# darwin

```{toctree}
:maxdepth: 1
:caption: architecture
```

## 環境構築

```bash
cd ./nix
nix run github:LnL7/nix-darwin -- switch --flake ".#shuntaka"
```

Cask未サポートのGUIツールを手動インストール

* Kindle
* Happy Hacking Keyboard.app
* CompareMerge.app
* Testcontainers Desktop.app
