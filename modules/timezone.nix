{
  lib,
  config,
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

    config = {
      services.automatic-timezoned.enable = lib.mkIf (cfg == "automatic") true;
      time.timeZone = lib.mkIf (cfg != "automatic") cfg;
    };
}
