{ lib, config, ... }:
let cfg = config.modules.timezone;
in {
  options.modules.timezone = lib.mkOption {
    default = "automatic";
    example = true;
    description = "Timezone.";
    type = lib.types.str;
  };

  config = {
    time.timeZone = if (cfg != "automatic") then cfg else null;
    services.automatic-timezoned.enable = lib.mkIf (cfg == "automatic") true;
  };
}
