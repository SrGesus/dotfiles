{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.05";
    };
  };
  
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      graz = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/graz/default.nix ];
      };
    };
  };
}
