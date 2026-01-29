{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  hosts.bilbao = {
    system = "x86_64-linux";
    modules = with config.flake.nixosModules; [
      bilbao
      sshd
      laptop
      ./_hardware.nix
    ];
  };

  flake.nixosModules.bilbao = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    home-manager.users.user = {

      imports = with config.flake.homeModules; [
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

    services.xserver.xkb = {
      layout = "pt";
      variant = "";
    };
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
