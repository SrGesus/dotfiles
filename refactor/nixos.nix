inputs@{ ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (import ./lib { inherit lib; }) myLib;
  inherit (myLib) listModulesRecursive;

  systemModules = myLib.listModulesRecursive ./modules/system;
  homeModules = myLib.listModulesRecursive ./modules/home;

  profiles = myLib.rakeLeaves ./profiles;

  mkHosts =
    dir:
    builtins.mapAttrs (
      host: filetype:
      lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            profiles
            ;
        };
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
          inputs.home.nixosModules.home-manager
          (dir + "/${host}")
        ] ++ systemModules;
      }
    ) (builtins.readDir dir);

in
{
  nixosConfigurations = mkHosts ./hosts;
}
