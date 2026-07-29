{
  flake.nixosModules.graphical-utils =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qalculate-qt
        wl-clipboard-rs
        qbittorrent
        rpi-imager
        vlc
      ];
    };

  flake.nixosModules.shell-utils =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        _7zz
        unrar
        ncdu
        nvd
        nix-tree
        age
      ];
    };
}
