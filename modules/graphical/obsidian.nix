{ config, ... }:
{

  flake.homeModules.obsidian = {
    modules.obsidian.enable = true;
  };

  flake.homeModules.obsidian' =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkEnableOption mkIf;
      cfg = config.modules.obsidian;
    in
    {
      options.modules.obsidian = {
        enable = mkEnableOption "obsidian";
      };

      config.home.packages = mkIf cfg.enable (
        with pkgs;
        [
          obsidian
        ]
      );
    };

  commonHomeModules = [
    config.flake.homeModules.obsidian'
  ];
}
