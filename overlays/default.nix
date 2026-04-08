{ self, nixpkgs-deno-pinned }:
final: prev: {
  sources = final.callPackage "${self}/_sources/generated.nix" { };

  inherit ((import nixpkgs-deno-pinned {
      inherit (final) system;
    })) deno;

  direnv = prev.direnv.overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or { }) // {
      CGO_ENABLED = "1";
    };
  });
}
