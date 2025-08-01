{ lib, config, ... }:
let
  cfg = config.modules.hardware;
in
{
  options.modules.hardware = {
    raspberrypi5 = lib.mkEnableOption "Raspberry pi 5 hardware modules";
  };

  config = {
    imports =
      if cfg.raspberrypi5 then
        with nixos-raspberrypi.nixosModules;
        [
          raspberry-pi-5.base
          raspberry-pi-5.bluetooth
        ]
      else
        [

        ];
  };
}
