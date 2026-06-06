{ config, ... }:
{
  flake.homeModules.android =
    { lib, ... }:
    let
      inherit (lib) mkEnableOption;
    in
    {
      options.modules.adb = {
        enable = mkEnableOption "adb";
      };
    };

  flake.nixosModules.android =
    { config, lib, pkgs, ... }:
    let
      inherit (lib)
        mkIf
        attrValues
        any
        mapAttrs
        ;
    in
    {
      environment.systemPackages = mkIf (any (value: value.modules.adb.enable) (attrValues config.home-manager.users)) [ pkgs.android-tools ];

      users.users = mapAttrs (
        _: value: mkIf value.modules.adb.enable { extraGroups = [ "adbusers" ]; }
      ) config.home-manager.users;
    };

  commonHomeModules = [
    config.flake.homeModules.android
  ];

  commonNixosModules = [
    config.flake.nixosModules.android
  ];
}
