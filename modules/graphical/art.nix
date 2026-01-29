{ ... }:
{
  flake.homeModules.art =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.art
        pkgs.gimp
        pkgs.inkscape
      ];
    };
}
