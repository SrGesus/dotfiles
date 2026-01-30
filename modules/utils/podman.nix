{ config, ... }:
{
  flake.nixosModules.podman = {
    modules.podman.enable = true;
  };

  flake.nixosModules.podman' =
    { config, lib, ... }:
    {
      options.modules.podman.enable = lib.mkEnableOption "podman";

      config = lib.mkIf config.modules.podman.enable {
        virtualisation = {
          containers.enable = true;
          podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
          };
        };
      };
    };

  commonNixosModules = [
    config.flake.nixosModules.podman'
  ];
}
