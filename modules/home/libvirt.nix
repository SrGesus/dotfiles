{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.libvirtd;
in
{
  options.modules.libvirtd = {
    enable = mkEnableOption "libvirtd";
  };

  config.dconf.settings = mkIf cfg.enable {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
