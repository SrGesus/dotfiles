# Things that are to be inserted into every host configuration
{
  config,
  inputs,
  ...
}@top-level:
let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) types;
  hostType = types.submodule (
    { config, ... }:
    {
      options = {
        system = lib.mkOption {
          type = types.str;
          # default = "x86_64-linux";
          default = if config.rpi then "aarch64-linux" else "x86_64-linux";
        };
        rpi = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Whether this host is a Raspberry Pi.";
        };
        plasma-manager = lib.mkEnableOption "plasma-manager";
        modules = lib.mkOption {
          type = types.listOf types.deferredModule;
          default = [ ];
          description = "List of modules for system.";
        };
      };
    }
  );
in
{
  options = {
    hosts = lib.mkOption {
      type = types.attrsOf hostType;
      example = ''
        bilbao = {
          modules = [
            self.nixosModules.bilbao
          ];
        }
      '';
    };
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (
    name: value:
    # TODO: if rpi then use the nixos-raspberrypi system function instead
    lib.nixosSystem {
      modules = [
        (
          { ... }:
          {
            networking.hostName = name;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # extraSpecialArgs = { inherit myLib; };
              sharedModules = [
                inputs.plasma-manager.homeModules.plasma-manager
                top-level.config.flake.homeModules.common
              ];
            };
            environment.systemPackages = [
              inputs.agenix.packages."${value.system}".default
            ];
          }
        )
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
        top-level.config.flake.nixosModules.common
      ]
      ++ value.modules;
    }
  ) config.hosts;
}
