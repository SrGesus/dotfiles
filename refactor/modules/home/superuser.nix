{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.superuser;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.modules = {
    superuser = mkEnableOption "admin permissions for this user";
    isNormalUser = mkEnableOption "Indicates whether this is an account for a “real” user.";
  };

  # config = mkIf cfg {
  # };
}
