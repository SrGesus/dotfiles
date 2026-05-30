{ config, ... }:
{
  flake.nixosModules.libreoffice =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        libreoffice-qt
        hunspell
        hunspellDicts.uk_UA
        hunspellDicts.th_TH
      ];
    };
}
