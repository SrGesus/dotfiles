{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      graz = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/graz/configuration.nix ];
      };
    };
  };
}
