{
  self,
  nixpkgs-deno-pinned,
  nixpkgs-mise-pinned,
  nixpkgs-cargo-watch-pinned,
}:
final: prev: {
  sources = final.callPackage "${self}/_sources/generated.nix" { };

  inherit
    (
      (import nixpkgs-deno-pinned {
        inherit (final.stdenv.hostPlatform) system;
      })
    )
    deno
    ;

  # Pin mise to a separate nixpkgs to bypass our direnv overlay below.
  # The overlay changes direnv's hash, which would otherwise force mise
  # (which references direnv) to be rebuilt from source.
  inherit
    (
      (import nixpkgs-mise-pinned {
        inherit (final.stdenv.hostPlatform) system;
      })
    )
    mise
    ;

  # Pin cargo-watch to a stable channel that has cached binaries.
  # unstable の cargo-watch は mac-notification-sys の linker が
  # aarch64-darwin で SIGTRAP して source build できないため回避。
  inherit
    (
      (import nixpkgs-cargo-watch-pinned {
        inherit (final.stdenv.hostPlatform) system;
      })
    )
    cargo-watch
    ;

  direnv = prev.direnv.overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or { }) // {
      CGO_ENABLED = "1";
    };
  });
}
