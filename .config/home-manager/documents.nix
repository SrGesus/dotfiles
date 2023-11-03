{pkgs, ...}:
{
  home.packages = with pkgs; [
    yed
    inkscape
  ];
}