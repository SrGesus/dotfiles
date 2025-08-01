{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nixos-raspberrypi = {
      # inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nvmd/nixos-raspberrypi/main";
    };
    home = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.05";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-raspberrypi,
      ...
    }:
    let
      lib = inputs.nixpkgs.lib;
      myLib = import ./lib ({
        inherit
          inputs
          # pkgs
          ;
        lib = lib;
      });
    in
    {
      nixosConfigurations = {
        graz = nixos-raspberrypi.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = inputs;
          modules = [
            ./hosts/graz/default.nix
            inputs.home.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ]
          ++ (lib.collect builtins.isPath (myLib.rakeLeaves ./modules));
        };
      };
    };
}
