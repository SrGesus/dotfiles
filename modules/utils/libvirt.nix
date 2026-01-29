{ config, lib, ... }:
{
  flake.homeModules.libvirtd = {
    modules.libvirtd.enable = true;
  };

  flake.homeModules.libvirtd' =
    { config, ... }:
    {
      options.modules.libvirtd.enable = lib.mkEnableOption "libvirtd";

      config = lib.mkIf config.modules.libvirtd.enable {
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = [ "qemu:///system" ];
            uris = [ "qemu:///system" ];
          };
        };
      };
    };

  flake.nixosModules.libvirtd' =
    { config, pkgs, ... }:
    let
      anyUserHasLibvirtd = builtins.any (value: value.modules.libvirtd.enable) (
        builtins.attrValues config.home-manager.users
      );
    in
    {
      config = lib.mkIf anyUserHasLibvirtd {

        virtualisation = {
          spiceUSBRedirection.enable = true;
          libvirtd = {
            enable = true;
            nss = {
              enable = true;
              enableGuest = true;
            };
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
        };

        users.users = builtins.mapAttrs (
          name: value: lib.mkIf value.modules.libvirtd.enable { extraGroups = [ "libvirtd" ]; }
        ) config.home-manager.users;

        programs.virt-manager.enable = true;
      };
    };

  commonHomeModules = [
    config.flake.homeModules.libvirtd'
  ];

  commonNixosModules = [
    config.flake.nixosModules.libvirtd'
  ];
}
