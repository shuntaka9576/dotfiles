_: {
  programs.git = {
    enable = true;
    lfs = {
      enable = true;
    };
    ignores = [
      ".vim"
      ".DS_Store"
      ".fdignore"
      "CLAUDE.local.md"
      ".claude/settings.local.json"
    ];
    settings = {
      user = {
        name = "shuntaka9576";
        email = "shuntaka9576@gmail.com";
      };
      ghq = {
        root = "~/repos";
      };
      core = {
        editor = "nvim -c \"set fenc=utf-8\"";
        pager = "cat";
      };
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
      alias = {
        sync-main = "!git remote update --prune && git branch -f main origin/main";
        rbsync = "!sh -c ''\n          set -e\n          git diff --quiet || { echo \"Working tree dirty\"; exit 1; }\n          git fetch --prune origin\n          base=$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null || (git remote set-head origin --auto >/dev/null; echo origin/HEAD))\n          echo \"Rebasing onto $base\"\n          git rebase \"$base\"\n        ''";
      };
    };
  };
}
