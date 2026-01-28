{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      options.modules.fonts = lib.mkEnableOption "fonts";
      config = {
        fonts = {
          fontconfig = {
            enable = true;
            defaultFonts = {
              monospace = [
                "DroidSansM Nerd Font Mono"
              ];
            };
          };
          packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            nerd-fonts.fira-code
            nerd-fonts.droid-sans-mono
          ];
        };
      };
    };

  commonNixosModules = [
    config.flake.nixosModules.fonts
  ];
}
