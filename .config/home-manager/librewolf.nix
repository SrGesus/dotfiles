{config, pkgs, ...}:
{
  home.packages = [
    pkgs.librewolf
  ];

  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.sessions" = false;

    };
  };
}