{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.photography;
in {
  options.modules.photography = {
    enable = mkEnableOption "photo editting software";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.art
      pkgs.gimp
    ];
  };
}
