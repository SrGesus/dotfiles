{ pkgs, ... }:
{

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
}
