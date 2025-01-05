{ self }:
final: prev: {
  sources = final.callPackage "${self}/_sources/generated.nix" { };
}
