{ lib, config, pkgs, ... }:
let
  cfg = config.modules.vscode;
  inherit (lib) mkIf mkEnableOption;
in {
  options.modules.vscode = { enable = mkEnableOption "vscode"; };

  config.programs.vscode = mkIf cfg.enable {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [ jnoortheen.nix-ide ];
  };

  config.home.packages = mkIf cfg.enable [ pkgs.nixfmt ];
}
