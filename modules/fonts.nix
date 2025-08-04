
{ lib, config, ... }:
let
  cfg = config.modules.home-manager;
in
{
  options.modules.home-manager = lib.mapAttrs (user: set: {
    nerdFonts = {
      enable = lib.mkEnableOption "nerd fonts";
    };
  }) config.users.users;

  config.home-manager.users = lib.mapAttrs (
    user: value:
    lib.mkIf value.nerdFonts.enable {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
      ];
    }
  ) cfg
}
