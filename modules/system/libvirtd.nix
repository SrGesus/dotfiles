{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    attrValues
    any
    mapAttrs
    ;
in
{
  virtualisation.libvirtd =
    mkIf (any (value: value.modules.libvirtd.enable) (attrValues config.home-manager.users))
      {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          # ovmf = {
          #   # not needed in NixOS 25.11 since https://github.com/NixOS/nixpkgs/pull/421549
          #   enable = true;
          #   packages = [
          #     (pkgs.OVMF.override {
          #       secureBoot = true;
          #       tpmSupport = true;
          #     }).fd
          #   ];
          # };
        };
      };

  users.users = mapAttrs (
    name: value: mkIf value.modules.libvirtd.enable { extraGroups = [ "libvirtd" ]; }
  ) config.home-manager.users;
}
