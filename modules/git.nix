{ lib, config, ... }:
let
  cfg = config.modules.home-manager;
  # mkHomeIf = set: attr: set ? attr && lib.getAttr set attr;
  # mkHomeIfDefaultFalse = set: attr: !(attr set ? attr) || lib.getAttr set attr;
in
{

  # options.modules.git = {
  # };

  options.modules.home-manager = lib.mapAttrs (user: set: {
    git = {
      enable = lib.mkEnableOption "git module";
      safeDirs = lib.mkEnableOption "marking all directories as safe in git";
      delta.enable = lib.mkEnableOption "git delta";
    };
  }) config.users.users;

  config.home-manager.users = lib.mapAttrs (
    user: value:
    lib.mkIf value.git.enable {
      programs.git = {
        enable = true;

        userName = "SrGesus";
        userEmail = "108523575+SrGesus@users.noreply.github.com";

        extraConfig = {
          safe.directory = lib.mkIf value.git.safeDirs "*";
        };
        delta = lib.mkIf value.git.delta.enable {
          enable = true;
          options = {
            features = "decorations";
            line-numbers = true;
            # Workaround for https://github.com/dandavison/delta/issues/1663
            # dark = true;
          };
        };
      };
    }
  ) config.modules.home-manager;
}
