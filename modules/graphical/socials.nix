{ inputs, lib, ... }:
let
  inherit (lib) types;
in
{
  flake.homeModules.discord = {
    modules.discord.enable = true;
  };

  commonHomeModules = [
    (
      { config, pkgs, ... }:
      {
        options.modules.discord.enable = lib.mkEnableOption "discord";
        options.modules.discord.package = lib.mkOption {
          default = pkgs.legcord;
          defaultText = "pkgs.legcord";
          type = types.package;
          description = "Package for discord.";
        };

        config.home.packages = lib.mkIf config.modules.discord.enable [
          pkgs.legcord
          config.modules.discord.package
        ];
      }
    )
  ];
}
