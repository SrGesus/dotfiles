{ config, ... }@top-level:
{
  hosts.versailles = {
    system = "x86_64-linux";
    modules = with config.flake.nixosModules; [
      versailles
      laptop
      lanzaboote
      podman
      ./_hardware.nix
    ];
  };

  flake.nixosModules.versailles =
    { config, pkgs, ... }:
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Use latest kernel.
      boot.kernelPackages = pkgs.linuxPackages_latest;

      boot.initrd.luks.devices."luks-99988361-54f3-4f11-83b2-b93e6ca59724".device =
        "/dev/disk/by-uuid/99988361-54f3-4f11-83b2-b93e6ca59724";
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      modules = {
        # timezone = "Europe/Lisbon";
      };

      home-manager.users.user = {

        imports = with top-level.config.flake.homeModules; [
          art
          discord
          games
          beancount
          obsidian
          desktop
          libvirtd
          vscode
          kdeconnect
          keepass
        ];

        modules = {
          superuser = true;
          isNormalUser = true;
        };

        home.stateVersion = "25.11";
      };

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "pt";
        variant = "";
      };

      # Configure console keymap
      console.keyMap = "pt-latin1";

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    };
}
