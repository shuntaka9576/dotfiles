{ pkgs, ... }:

{
  home.file."Library/Application Support/ai.bloop.vibe-kanban/profiles.json" = {
    source = ./profiles.json;
  };
}
