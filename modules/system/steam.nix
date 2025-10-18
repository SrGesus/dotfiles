{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.steam;
in {
  options.modules.steam = {
    enable = mkEnableOption "steam";
  };

  config.programs.steam = mkIf cfg.enable {
    enable = true;
    protontricks.enable = true;
  };

  config.fonts.packages = [
    pkgs.freetype
  ];
}
