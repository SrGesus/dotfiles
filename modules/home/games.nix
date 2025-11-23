{
  config,
  pkgs,
  myLib,
  lib,
  ...
}:
let
  cfg = config.modules.games;
  inherit (myLib) mkIfList;
  inherit (lib) mkEnableOption;
in
{
  options.modules.games = {
    minecraft = mkEnableOption "minecraft";
  };

  config.home.packages = (mkIfList cfg.minecraft [ pkgs.prismlauncher ]) ++ [
    pkgs.wineWow64Packages.full
    pkgs.winetricks
    pkgs.nexusmods-app
  ];

  config.programs.lutris = {
    enable = true;
    winePackages = [ pkgs.wineWow64Packages.full ];
    extraPackages = with pkgs; [
      libadwaita
      gtk4
    ];
  };
}
