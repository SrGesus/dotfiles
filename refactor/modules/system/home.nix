{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf optionals;
  networkmanager = config.networking.networkmanager.enable;
in
{
  # users.users.user.isNormalUser=true;
  users.users = builtins.mapAttrs (name: value: {
    isNormalUser = value.modules.isNormalUser;
    extraGroups =
      optionals value.modules.superuser [ "wheel" ]
      ++ optionals (value.modules.isNormalUser && networkmanager) [ "networkmanager" ];
  }) config.home-manager.users;
}
