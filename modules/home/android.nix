{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.modules.adb = {
    enable = mkEnableOption "adb";
  };
}
