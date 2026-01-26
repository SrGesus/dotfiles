{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
  ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager.users.user = {
    modules = {
    };

    home.stateVersion = "25.05";
  };
}
