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
    let
      networkmanager = config.networking.networkmanager.enable;
    in
    {
      users.users = builtins.mapAttrs (name: value: {
        isNormalUser = value.modules.isNormalUser;
        extraGroups =
          lib.optionals value.modules.superuser [ "wheel" ]
          ++ lib.optionals (value.modules.isNormalUser && networkmanager) [ "networkmanager" ];
      }) config.home-manager.users;
    };

  commonHomeModules = [
    config.flake.homeModules.user
  ];
  commonNixosModules = [
    config.flake.nixosModules.user
  ];
}
