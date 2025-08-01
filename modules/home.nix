{ lib, config, ... }:
let
  cfg = config.modules.home-manager;
in
{
  options.modules.home-manager = mkOption {
    type = lib.types.attrs;
    default = { };
  };

  config.home-manager.users = lib.mapAttr (
    user: value:
    lib.mkIf value.enabled {
      username = user;
    }
  ) cfg;

}
