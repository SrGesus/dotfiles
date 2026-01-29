# Declare flake.homeModules as an option identical to nixosModules
# https://github.com/hercules-ci/flake-parts/blob/80daad04eddbbf5a4d883996a73f3f542fa437ac/modules/nixosModules.nix
{ self, lib, moduleLocation, ... }:
let
  inherit (lib)
    mapAttrs
    mkOption
    types
    ;
in
{
  options = {
    flake.homeModules = mkOption {
      type = types.lazyAttrsOf types.deferredModule;
      default = { };
      apply = mapAttrs (k: v: {
        _class = "homeManager";
        _file = "${toString moduleLocation}#homeModules.${k}";
        imports = [ v ];
      });
      description = ''
        Home Manager modules.

        You may use this for reusable pieces of configuration, service modules, etc.
      '';
    };
  };
}
