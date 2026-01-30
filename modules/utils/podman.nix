{ config, ... }:
{
  flake.nixosModules.podman = {
    modules.podman.enable = true;
  };

  flake.nixosModules.podman' =
    { config, lib, pkgs, ... }:
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
        environment.systemPackages = with pkgs; [
          podman-compose
        ];
      };
    };

  commonNixosModules = [
    config.flake.nixosModules.podman'
  ];
}
