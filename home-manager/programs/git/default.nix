_: {
  programs.git = {
    enable = true;
    userName = "shuntaka9576";
    userEmail = "shuntaka9576@gmail.com";
    ignores = [
      ".vim"
      ".DS_Store"
    ];
    extraConfig = {
      ghq = {
        root = "~/repos";
      };
      user = {
        name = "shuntaka9576";
        email = "shuntaka9576@gmail.com";
      };
      core = {
        editor = "nvim -c \"set fenc=utf-8\"";
      };
      push = {
        default = "current";
      };
      alias = {
        see = "browse";
      };
      hub = {
        protocol = "https";
      };
      credential = {
        helper = "osxkeychain";
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
