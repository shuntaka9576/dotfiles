{ ... }:
{
  programs.git = {
    enable = true;
    userName  = "shuntaka9576";
    userEmail = "shuntaka9576@gmail.com";
    ignores = [
      ".vim"
      ".DS_Store"
    ];
    extraConfig = {
      pull = {
        rebase = false;
      };
    };
  };
}
