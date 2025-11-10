{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.libvirtd;
in
{
  options.modules.libvirtd = {
    enable = mkEnableOption "libvirtd";
  };

  config.home.packages = mkIf cfg.enable [
    pkgs.virt-manager
    pkgs.virt-viewer
  ];
}
