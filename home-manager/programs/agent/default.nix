{
  config,
  ...
}:
let
  # Local skills managed in this repo (external skills managed by APM)
  localSkills = [
    "git-git-commit"
    "git-create-pr"
    "github-ci-watch"
    "git-merge-pr"
    "github-analyze-dependabot-alerts"
    "aws-logs-investigate"
    "aws-profiles"
    "aws-vault-exec"
    "it-news-digest"
  ];

  # Deploy targets for local skills
  skillTargets = [
    ".claude/skills"
    ".codex/skills"
    ".config/opencode/skills"
    ".copilot/skills"
  ];

  skillsDir = "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/skills";

  mkSkillEntries =
    target:
    builtins.listToAttrs (
      map (name: {
        name = "${target}/${name}";
        value.source = config.lib.file.mkOutOfStoreSymlink "${skillsDir}/${name}";
      }) localSkills
    );
in
{
  imports = [ ./mcp/default.nix ];

  home.file =
    builtins.foldl' (acc: target: acc // mkSkillEntries target) { } skillTargets
    // {
      ".apm/apm.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/programs/agent/apm.yml";
    };
}
