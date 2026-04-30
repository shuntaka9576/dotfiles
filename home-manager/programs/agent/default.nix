{
  config,
  pkgs,
  ...
}:
let
  # Local skills managed in this repo
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

  # Third-party gws skills (shared + services + helpers, excluding recipes/personas)
  gwsSkills = [
    "gws-shared"
    "gws-admin-reports"
    "gws-calendar"
    "gws-calendar-agenda"
    "gws-calendar-insert"
    "gws-chat"
    "gws-chat-send"
    "gws-classroom"
    "gws-docs"
    "gws-docs-write"
    "gws-drive"
    "gws-drive-upload"
    "gws-events"
    "gws-events-renew"
    "gws-events-subscribe"
    "gws-forms"
    "gws-gmail"
    "gws-gmail-forward"
    "gws-gmail-reply"
    "gws-gmail-reply-all"
    "gws-gmail-send"
    "gws-gmail-triage"
    "gws-gmail-watch"
    "gws-keep"
    "gws-meet"
    "gws-modelarmor"
    "gws-modelarmor-create-template"
    "gws-modelarmor-sanitize-prompt"
    "gws-modelarmor-sanitize-response"
    "gws-people"
    "gws-sheets"
    "gws-sheets-append"
    "gws-sheets-read"
    "gws-slides"
    "gws-tasks"
    "gws-workflow"
    "gws-workflow-email-to-task"
    "gws-workflow-file-announce"
    "gws-workflow-meeting-prep"
    "gws-workflow-standup-report"
    "gws-workflow-weekly-digest"
  ];

  # Third-party babarot/gh-infra skills
  ghInfraSkills = [
    "ci-cd"
    "file-manifest"
    "gh-infra"
    "import-into"
    "repository-manifest"
  ];

  # Deploy targets for agent skills
  skillTargets = [
    ".config/claude/skills"
    ".codex/skills"
    ".copilot/skills"
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

      gwsEntries = builtins.listToAttrs (
        map (name: {
          name = "${target}/${name}";
          value.source = "${pkgs.sources.google-workspace-cli.src}/skills/${name}";
        }) gwsSkills
      );

      ghInfraEntries = builtins.listToAttrs (
        map (name: {
          name = "${target}/${name}";
          value.source = "${pkgs.sources.gh-infra.src}/skills/${name}";
        }) ghInfraSkills
      );

      thirdPartyEntries = {
        "${target}/playwright-cli".source = "${pkgs.sources.playwright-cli.src}/skills/playwright-cli";
        "${target}/skill-creator".source = "${pkgs.sources.anthropic-skills.src}/skills/skill-creator";
        "${target}/worktrunk".source = "${pkgs.sources.worktrunk.src}/skills/worktrunk";
        "${target}/zenn-markdown".source = "${pkgs.sources.zenn-markdown-skill.src}/skills/zenn-markdown";
      };
    in
    localEntries // gwsEntries // ghInfraEntries // thirdPartyEntries;
in
{
  imports = [ ./mcp/default.nix ];

  home.file = builtins.foldl' (acc: target: acc // mkSkillEntries target) { } skillTargets;
}
