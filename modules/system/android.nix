{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf attrValues any mapAttrs;
in
{
  programs.adb.enable = any (value: value.modules.adb.enable) (attrValues config.home-manager.users);

  users.users = mapAttrs (name: value: mkIf value.modules.adb.enable {extraGroups = ["adbusers"];} ) config.home-manager.users;
}
