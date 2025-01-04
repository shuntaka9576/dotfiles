{ pkgs, platform, rust-bin, ... }:
{
home.packages = with pkgs; [
    gnumake
    gcc
    code2prompt
    go
    jq
    shellcheck
    wget
    duckdb
    ripgrep
    eza
    bat
    gitui
    stylua
    taplo-cli
    cargo-edit
    cargo-watch
    # cargo-compete
    sqlx-cli
    cargo-make
    rust-bin.stable.latest.default
    docker
    ghq
    awscli2
    google-java-format
    zenn-cli
    fontconfig
    lua
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.hack
    plemoljp-nf
  ] ++ lib.optionals (platform == "aarch64-darwin") [
    reattach-to-user-namespace
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = pkgs.lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
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
