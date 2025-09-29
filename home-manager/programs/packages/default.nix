{
  pkgs,
  system,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      gnumake
      gcc
      mysql84
      code2prompt
      duckdb
      go
      jq
      shellcheck
      wget
      duckdb
      ripgrep
      eza
      bat
      # gitui
      stylua
      taplo-cli
      cargo-edit
      cargo-watch
      sqlx-cli
      cargo-make
      docker
      tokei
      ghq
      awscli2
      hey
      google-java-format
      goreleaser
      zenn-cli
      fontconfig
      lua
      typst
      luarocks
      yamlfmt
      # rust-bin.beta.latest.default
      # rustup
      nixfmt-rfc-style
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.hack
      plemoljp-nf
      ngrok
      go-jsonnet
      ssm-session-manager-plugin
      shfmt
      nkf
    ]
    ++ lib.optionals (system == "aarch64-darwin") [ reattach-to-user-namespace ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = pkgs.lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      serif = [
        "Noto Serif"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Noto Sans CJK JP"
        "Noto Sans"
        "Noto Color Emoji"
      ];
      monospace = [
        "Noto Sans Mono"
        "Noto Color Emoji"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
