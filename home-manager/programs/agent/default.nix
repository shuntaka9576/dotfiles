{
  config,
  pkgs,
  ...
}:
let
  # Local skills managed in this repo
  localSkills = [
    "git:git-commit"
    "git:create-pr"
    "git:merge-pr"
    "github:analyze-dependabot-alerts"
    "aws:logs-investigate"
    "aws:profiles"
    "aws:vault-exec"
  ];

  # Deploy targets for agent skills
  skillTargets = [
    ".config/claude/skills"
    ".codex/skills"
    ".config/opencode/skills"
  ];

  skillsDir = "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/skills";

  # Generate file entries for each target: local skills via mkOutOfStoreSymlink (instant updates),
  # third-party skills via Nix store paths (managed by nvfetcher)
  mkSkillEntries =
    target:
    let
      localEntries = builtins.listToAttrs (
        map (name: {
          name = "${target}/${name}";
          value.source = config.lib.file.mkOutOfStoreSymlink "${skillsDir}/${name}";
        }) localSkills
      );

      thirdPartyEntries = {
        "${target}/playwright-cli".source = "${pkgs.sources.playwright-cli.src}/skills/playwright-cli";
      };
    in
    localEntries // thirdPartyEntries;
in
{
  imports = [ ./mcp/default.nix ];

  home.file = builtins.foldl' (acc: target: acc // mkSkillEntries target) { } skillTargets;
}
