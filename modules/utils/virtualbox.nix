{ config, lib, ... }:
{
  flake.homeModules.virtualbox = {
    modules.virtualbox.enable = true;
  };

  flake.homeModules.virtualbox' =
    { config, ... }:
    {
      options.modules.virtualbox.enable = lib.mkEnableOption "virtualbox";

      config = lib.mkIf config.modules.virtualbox.enable {

        # Home manager config

      };
    };

  flake.nixosModules.virtualbox' =
    { config, pkgs, ... }:
    let
      anyUserHasVirtualbox = builtins.any (value: value.modules.virtualbox.enable) (
        builtins.attrValues config.home-manager.users
      );
    in
    {
      config = lib.mkIf anyUserHasVirtualbox {

        # System wide config
        virtualisation.virtualbox.host.enable = true;
        virtualisation.virtualbox.host.enableExtensionPack = true;
        # virtualisation.virtualbox.guest.enable = true;
        # virtualisation.virtualbox.guest.dragAndDrop = true;
        users.users = builtins.mapAttrs (
          name: value:
          lib.mkIf value.modules.virtualbox.enable { extraGroups = [ "user-with-access-to-virtualbox" ]; }
        ) config.home-manager.users;
      };
    };

  commonHomeModules = [
    config.flake.homeModules.virtualbox'
  ];

  commonNixosModules = [
    config.flake.nixosModules.virtualbox'
  ];
}
