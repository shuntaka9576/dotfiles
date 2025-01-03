{ pkgs, lib, ... }:
let
  memo = pkgs.buildGoModule rec {
    pname = "memo";
    version = "0.0.17";

    src = pkgs.fetchFromGitHub {
      owner = "mattn";
      repo = "memo";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-f6BHKA/G5WhYBh1ruCVb1BwVK6vvmC3XVakqnshFfmk=";
    };
    vendorHash = "sha256-aO6Bf8omdePK1vV9uxfTJyjdzAykCfOibY5zWbOlJCg=";
  };
in
{
  home.packages = [
    memo
  ];
  home.file.".config/memo/config.toml".text = ''
    memodir = "$GHQ_ROOT/github.com/shuntaka9576/memo"
    memotemplate = "~/dotfiles/nix/home-manager/programs/memo/memo-template.md"
    editor = "nvim"
    column = 20
    width = 0
    selectcmd = 'find $GHQ_ROOT/github.com/shuntaka9576/memo -type f |sort -r |grep -v "/\.git/" | grep -v -e "ignore" -v -e "^\.gitkeep" |sed -e "s|$GHQ_ROOT/github.com/shuntaka9576/memo/||g" |fzf'
    grepcmd = "grep -nH ''${PATTERN} ''${FILES}"
    assetsdir = "."
    pluginsdir = "~/.config/memo/plugins"
    templatedirfile = ""
    templatebodyfile = ""
  '';
}
