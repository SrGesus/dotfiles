{ lib, config, ... }:
let
  cfg = config.modules.home-manager;
in
{
  options.modules.home-manager = lib.mapAttrs (
    user: set: {
      enable = lib.mkEnableOption "home-manager for this user.";
    }
  ) config.users.users;

  config.home-manager.users = lib.mapAttrs (
    user: value:
    lib.mkIf value.enable {
      home = {

        username = user;
        stateVersion = config.system.stateVersion;
      };

      programs.home-manager.enable = true;

    }
  ) cfg;
}
