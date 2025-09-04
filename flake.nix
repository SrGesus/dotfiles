{
  description = "SrGesus NixOS Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    home = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.05";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
      inherit (inputs.nixpkgs) lib;
      inherit (import ./lib { inherit lib; }) myLib;

      systemModules = myLib.listModulesRecursive ./modules/system;
      homeModules = myLib.listModulesRecursive ./modules/home;

      mkHosts = dir: builtins.mapAttrs (host: filetype: lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          {
            networking.hostName = host;
            nixpkgs.config.allowUnfree = true;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit myLib; };
              sharedModules = homeModules;
            };
          }
          (dir + "/${host}")
          inputs.home.nixosModules.home-manager
        ] ++ systemModules;
      }) (builtins.readDir dir);
  in {
    nixosConfigurations = mkHosts ./hosts;
  };
}
