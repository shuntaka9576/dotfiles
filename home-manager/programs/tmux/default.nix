{ pkgs, config, ... }:
let
  tmux-file-picker = pkgs.stdenv.mkDerivation {
    pname = "tmux-file-picker";
    version = "local";
    src = ./scripts;
    installPhase = ''
      mkdir -p $out/bin
      cp tmux-file-picker.sh $out/bin/tmux-file-picker
      cp grep-preview.sh $out/bin/grep-preview
      chmod +x $out/bin/tmux-file-picker $out/bin/grep-preview
    '';
    postFixup = ''
      wrapProgram $out/bin/tmux-file-picker \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.fzf
            pkgs.fd
            pkgs.bat
            pkgs.ripgrep
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
  home.file.".config/tmux/scripts/tmux-sort-windows.sh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/tmux/scripts/tmux-sort-windows.sh";
  };
  home.file.".tmux/plugins/resurrect" = {
    source = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
  };
  home.file.".tmux/plugins/continuum" = {
    source = "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum";
  };
}
