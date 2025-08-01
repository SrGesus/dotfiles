{ lib, config, ... }:
let
  cfg = config.modules.home-manager;
in
{
  options.modules.home-manager = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };

  config.home-manager.users = lib.mapAttrs (
    user: value:
    lib.mkIf value.enable {
      home.username = user;
    }
  ) cfg;

}
