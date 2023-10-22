{config, pkgs, ...}:
{
  home.packages = [
    pkgs.gtk
  ];

  programs.gtk = {
    enable = true;

    font.name = "Iosevka Nerd font 14";
    fonts.monospace = "Iosevka Nerd font 14";

    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    icontheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    }
  };
}