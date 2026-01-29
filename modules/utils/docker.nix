{ config, ... }:
{
  flake.nixosModules.docker = {
    modules.docker.enable = true;
  };

  flake.nixosModules.docker' =
    { config, lib, ... }:
    {
      options.modules.docker.enable = lib.mkEnableOption "docker";

      config = lib.mkIf config.modules.docker.enable {
        virtualisation.docker = {
          enable = true;
          enableOnBoot = false;
        };
      };
    };

  commonNixosModules = [
    config.flake.nixosModules.docker'
  ];
}
