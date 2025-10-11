{ lib, config, pkgs, ... }: let 
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.nerdFonts;
in {
  options.modules.nerdFonts = {
    enable = lib.mkEnableOption "nerd fonts";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      freetype
    ];
  };
}
