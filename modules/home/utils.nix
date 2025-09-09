{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.qalculate-qt
  ];
}
