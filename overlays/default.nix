{ self }:
final: prev: {
  sources = final.callPackage "${self}/_sources/generated.nix" { };

  direnv = prev.direnv.overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or { }) // {
      CGO_ENABLED = "1";
    };
  });
}
