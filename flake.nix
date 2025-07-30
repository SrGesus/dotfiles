{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
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
  
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      graz = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/graz/default.nix ];
      };
    };
  };
}
