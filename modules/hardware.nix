{ lib, config, ... }:
let
  cfg = config.modules.hardware;
in
{
  options.modules.hardware = {
    # raspberrypi5 = lib.mkEnableOption "Raspberry Pi 5 hardware modules";
    keyboard = lib.mkOption {
      default = "pt";
      example = true;
      description = "Keyboard type.";
      type = lib.types.str;
    };
  };

  config = {
    # imports = (
    #   myLib.mkIfList cfg.raspberrypi5 (
    #     with nixos-raspberrypi.nixosModules;
    #     [
    #       raspberry-pi-5.base
    #       raspberry-pi-5.bluetooth
    #     ]
    #   )
    # );
  }
  // {
    # Keyboard
    # "pt" = {
      services.xserver.xkb = {
        layout = "pt";
        options = "eurosign:e,caps:escape";
      };
      console = {
        # font = "Lat2-Terminus16";
        keyMap = lib.mkForce "pt-latin9";
        useXkbConfig = true; # use xkb.options in tty.
      };
    };
  # }
  # ."${cfg.keyboard}";
}
