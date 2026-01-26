{ lib, config, ... }:
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

  config = {
    time.timeZone = if (cfg != "automatic") then cfg else null;
    services = lib.mkIf (cfg == "automatic") {
      automatic-timezoned.enable = true;
      geoclue2 = {
        enableDemoAgent = lib.mkForce true; # see: https://github.com/NixOS/nixpkgs/issues/68489#issuecomment-1484030107
        geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      };
    };
  };
}
