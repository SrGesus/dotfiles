{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.homeModules.user = {
    options.modules = {
      superuser = lib.mkEnableOption "Admin permissions for this user.";
      isNormalUser = lib.mkEnableOption "Indicates whether this is an account for a “real” user.";
    };
  };

  flake.nixosModules.user =
    { config, ... }:
    {
      users.users = builtins.mapAttrs (name: value: {
        isNormalUser = value.modules.isNormalUser;
        extraGroups =
          lib.optionals value.modules.superuser [ "wheel" ]
          ++ lib.optionals (value.modules.isNormalUser && config.networking.networkmanager.enable) [
            "networkmanager"
          ]
          ++ lib.optionals (value.modules.superuser && config.modules.docker.enable) [
            "docker"
          ];
      }) config.home-manager.users;
    };

  commonHomeModules = [
    config.flake.homeModules.user
  ];
  commonNixosModules = [
    config.flake.nixosModules.user
  ];
}
