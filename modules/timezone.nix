{
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.timezone;
in
{
  options.modules.timezone = lib.mkOption {
    default = "automatic";
    example = true;
    description = "Timezone.";
    type = lib.types.str;
  };

  config =
    if cfg == "automatic" then
      {
        time.timeZone = null; # Not managed by Nix
        services.automatic-timezoned.enable = true;
      }
    else
      {
        time.timeZone = cfg;
      };
}
