inputs@{ ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (import ./lib { inherit lib; }) myLib;
  inherit (myLib) listModulesRecursive;

  systemModules = myLib.listModulesRecursive ./modules/system;
  homeModules = myLib.listModulesRecursive ./modules/home;

  mkHosts =
    dir:
    builtins.mapAttrs (
      host: filetype:
      lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          {
            networking.hostName = host;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit myLib; };
              sharedModules = homeModules;
            };
          }
          (dir + "/${host}")
          inputs.home.nixosModules.home-manager

        ];
      }
    ) (builtins.readDir dir);

in
{
  nixosConfigurations = mkHosts ./hosts;
}
