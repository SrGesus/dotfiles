# These nixos and home modules that are either profiles that should be included everywhere
# Or modules that do nothing unless option is set
{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  options = {
    commonNixosModules = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
      default = [ ];
      description = "NixOS Modules common to every configuration.";
    };
    commonHomeModules = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
      default = [ ];
      description = "Common Home-Manager Modules common to every configuration.";
    };
  };

  config = {
    flake.homeModules.common.imports = config.commonHomeModules ++ [
      (
        { config, ... }:
        {
          modules = lib.mkIf config.modules.isNormalUser {
            git.enable = true;
            zsh.enable = true;
          };
        }
      )
    ];

    flake.nixosModules.common.imports = config.commonNixosModules ++ [
      (
        { pkgs, ... }:
        {
          imports = with config.flake.nixosModules; [
            locales
          ];

          nixpkgs.config.allowUnfree = true;

          nix = {
            extraOptions = ''
              experimental-features = nix-command flakes
            '';

            # registry.nixpkgs.flake = inputs.nixpkgs;

            settings.trusted-users = [
              "root"
              "@wheel"
            ];
          };
        }
      )
    ];
  };
}
