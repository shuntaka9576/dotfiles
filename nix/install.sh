#!/usr/bin/env bash
set -eu

export NIX_CONFIG="experimental-features = nix-command flakes"

user_name="shuntaka"

case "$(uname -sm)" in
  "Darwin arm64")   nix_platform="aarch64-darwin" ;;
  "Linux x86_64")   nix_platform="x86_64-linux" ;;
  *)
    echo "Unsupported platform: $(uname -sm)"
    exit 1
    ;;
esac

nix run nixpkgs#gnused -- -i "s|__SYSTEM__|${nix_platform}|g" flake.nix
nix run nixpkgs#gnused -- -i "s|__USERNAME__|${user_name}|g" flake.nix

if [[ "$nix_platform" == "aarch64-darwin" ]]; then
  nix run github:LnL7/nix-darwin -- switch --flake ".#${user_name}"
elif [[ "$nix_platform" == "x86_64-linux" ]]; then
  nix run nixpkgs#home-manager -- switch --flake .#shuntaka
else
  echo "Linux configuration not implemented yet"
fi
