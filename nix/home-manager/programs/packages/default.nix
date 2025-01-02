{ pkgs, rust-bin, ... }:
{
  home.packages = with pkgs; [
    gnumake
    ripgrep
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
  ];
}
