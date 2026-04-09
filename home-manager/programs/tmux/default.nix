{ pkgs, config, ... }:
let
  tmux-file-picker = pkgs.stdenv.mkDerivation {
    pname = "tmux-file-picker";
    inherit (pkgs.sources.tmux-file-picker) version;
    inherit (pkgs.sources.tmux-file-picker) src;
    installPhase = ''
      mkdir -p $out/bin
      cp tmux-file-picker $out/bin/tmux-file-picker
      chmod +x $out/bin/tmux-file-picker
    '';
    postFixup = ''
      wrapProgram $out/bin/tmux-file-picker \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.fzf
            pkgs.fd
            pkgs.bat
            pkgs.coreutils
          ]
        }
    '';
    nativeBuildInputs = [ pkgs.makeWrapper ];
  };
in
{
  home.packages = with pkgs; [
    tmux
    tmux-file-picker
  ];
  home.file.".tmux.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/tmux/.tmux.conf";
  };
}
