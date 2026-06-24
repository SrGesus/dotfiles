{
  config,
  inputs,
  ...
}@top-level:
{
  hosts.graz = {
    system = "aarch64-linux";
    rpi = true;
    modules = with config.flake.nixosModules; [
      graz
      laptop
      sshd
      vim
      locales
      ./_hardware.nix
      inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
      inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
    ];
  };

  flake.nixosModules.graz =
    { config, pkgs, lib, ... }:
    {
      modules = {
        timezone = "Europe/Lisbon";
      };

      services.displayManager = {
        autoLogin.user = "pi";
        sddm.enable = true;
        sddm.wayland.enable = true;
      };

      services.desktopManager.plasma6.enable = true;

      home-manager.users.user = {

        imports = with top-level.config.flake.homeModules; [
          kdeconnect
          helix
        ];

        modules = {
          superuser = true;
          isNormalUser = true;
        };

        home.stateVersion = "25.05";
      };

      security.sudo.wheelNeedsPassword = false;

      nix.settings.trusted-users = [
        "root"
        "pi"
      ];

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
      system.stateVersion = "25.05"; # Did you read the comment?
    };
}
