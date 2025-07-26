{config, pkgs, ...}:
{
  home.packages = [
    pkgs.git
    # pkgs.git-filter-repo
  ];

  programs.git = {
    enable = true;
    userName = "SrGesus";
    userEmail = "108523575+SrGesus@users.noreply.github.com";
    extraConfig = {
      safe.directory = "*";
    };
  };
}
