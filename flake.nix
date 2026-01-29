{
  description = "SrGesus NixOS System Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs@{ import-tree, flake-parts, ... }:
    flake-parts.lib.mkFlake
      { inherit inputs; }
      {
        imports = [
          (import-tree ./modules)
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      };

}
