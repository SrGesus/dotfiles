{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.obsidian;
in {
  options.modules.obsidian = {
    enable = mkEnableOption "obsidian";
  };

  config.programs.obsidian = mkIf cfg.enable {
    enable = true;
    vaults.default = {
      enable = true;
      target = "${config.home.homeDirectory}/Documents/vault/default";
    };
  };
}
