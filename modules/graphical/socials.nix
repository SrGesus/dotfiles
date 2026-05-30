{ inputs, lib, ... }:
let
  inherit (lib) types;
in
{
  flake.homeModules.discord = {
    modules.discord.enable = true;
  };

  flake.homeModules.signal = {
    modules.signal.enable = true;
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
        options.modules.signal.enable = lib.mkEnableOption "signal";

        config.home = lib.mkMerge [
          (lib.mkIf config.modules.discord.enable { packages = [ config.modules.discord.package ]; })
          (lib.mkIf config.modules.signal.enable { packages = [ pkgs.signal-desktop ]; })
        ];
      }
    )
  ];
}
