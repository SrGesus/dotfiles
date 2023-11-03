{config, pkgs, ...}:
{
  home.packages = [
    # pkgs.gtk
  ];

  gtk = {
    enable = true;

    font.name = "Iosevka Nerd Font 14";

    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };

    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };
}