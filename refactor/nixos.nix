inputs@{
  plasma-manager,
  home-manager,
  nixpkgs,
  ...
}:
let
  inherit (nixpkgs) lib;
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
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit myLib; };
              sharedModules = homeModules ++ [ plasma-manager.homeModules.plasma-manager ];
            };
          }
          home-manager.nixosModules.home-manager
          (dir + "/${host}")
        ]
        ++ systemModules;
      }
    ) (builtins.readDir dir);

in
{
  nixosConfigurations = mkHosts ./hosts;
}
