{
  description = "SrGesus NixOS System Configurations";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.flake-parts.lib) mkFlake;
    in
      mkFlake { inherit inputs; } {
        flake = import ./nixos.nix inputs;
        systems = [ "x86_64-linux" "aarch64-linux" ];
        perSystem = {...}: {
          
        };
      };
  
}
