_: {
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = false;
    };
    settings = {
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
        see = "browse";
      };
      editor = "nvim";
    };
  };
}
