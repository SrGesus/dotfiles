{config, pkgs, ...}:
{
  home.packages = [
    pkgs.vivaldi
  ];

  # programs.librewolf = {
  #   enable = true;
  #   settings = {
  #     "privacy.clearOnShutdown.history" = false;
  #     "privacy.clearOnShutdown.sessions" = false;
  #   };
  #   # extensions = [
  #   # doesn't work :(
  #   # ];
  # };
}