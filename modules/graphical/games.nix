{ lib, ... }:
{
  flake.homeModules.games = {
    modules.games.enable = true;
  };

  commonHomeModules = [
    (
      { pkgs, ... }:
      {
        options.modules.games.enable = lib.mkEnableOption "games";
        config = {

          home.packages = with pkgs; [
            prismlauncher
            wineWow64Packages.full
            winetricks
          ];

          programs.lutris = {
            enable = true;
            winePackages = with pkgs; [ wineWow64Packages.full ];
            extraPackages = with pkgs; [
              libadwaita
              gtk4
            ];
          };
        };
      }
    )
  ];

  commonNixosModules = [
    (
      { config, pkgs, ... }:
      {
        options.modules.steam = {
          enable = lib.mkOption {
            default = builtins.any (value: value.modules.games.enable) (
              builtins.attrValues config.home-manager.users
            );
            example = false;
            description = "Whether to install steam on this system.";
            type = lib.types.bool;
          };
        };

        config = {
          programs.steam = lib.mkIf config.modules.steam.enable {
            enable = true;
            protontricks.enable = true;
            extraCompatPackages = [
              pkgs.proton-ge-bin
            ];
          };

          fonts.packages = [
            pkgs.freetype
          ];
        };
      }
    )
  ];
}
