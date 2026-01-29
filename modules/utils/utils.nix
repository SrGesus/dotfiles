{
  flake.nixosModules.utils =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qalculate-qt
        wl-clipboard-rs
        qbittorrent
        rpi-imager
        _7zz
        unrar
      ];
    };
}
