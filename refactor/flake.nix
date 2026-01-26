{
  description = "SrGesus NixOS System Configurations";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    home = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
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