_: {
  programs.git = {
    enable = true;
    ignores = [
      ".vim"
      ".DS_Store"
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
      credential = {
        helper = [
          ""
          "!/opt/homebrew/bin/op plugin run -- gh auth git-credential"
        ];
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
    };
  };
}
