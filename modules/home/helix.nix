{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.helix;
in {
  options.modules.helix = {
    enable = mkEnableOption "helix";
  };

  config.programs.helix = mkIf cfg.enable {
    enable = true;
    defaultEditor = true;
  };
}
