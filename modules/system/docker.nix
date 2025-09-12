{ lib, config, ... }:
let
in
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
