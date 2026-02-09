{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  hosts.krakow = {
    system = "x86_64-linux";
    modules = with config.flake.nixosModules; [
      krakow
      sshd
      podman
      utils
      inputs.disko.nixosModules.disko
      vim
      ./_hardware.nix
      ./_disk.nix
    ];
  };

  flake.nixosModules.krakow = {
    boot.loader.grub = {
      # no need to set devices, disko will add all devices that have a EF02 partition to the list already
      # devices = [ ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      # Open TCP ports
      allowedTCPPorts = [
        22
        80
        443
        35422
      ];
      # Open UDP ports
      allowedUDPPorts = [ 443 ];
      # Open a range of ports
      # allowedTCPPortRanges = [
      #   {
      #     from = 4000;
      #     to = 4007;
      #   }
      # ];
    };

    networking.interfaces.enp1s0.ipv6.addresses = [
      {
        address = "2a01:4f9:c014:edfa::1";
        prefixLength = 64;
      }
    ];

    networking.defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };

    modules = {
      timezone = "Europe/Lisbon";
    };

    users.users.user = {
      subUidRanges = [
        { startUid = 100000; count = 262144; }
      ];
      subGidRanges = [
        { startGid = 100000; count = 262144; }
      ];
    };

    home-manager.users.user = {

      imports = with config.flake.homeModules; [

      ];

      modules = {
        superuser = true;
        isNormalUser = true;
      };

      home.stateVersion = "25.11";
    };

    users.users.user.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPO1/Mg1Q33F7J3k2A3sziZKeOZT1Cp9ODlYGbDA9HZ user@versailles"
    ];

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPO1/Mg1Q33F7J3k2A3sziZKeOZT1Cp9ODlYGbDA9HZ user@versailles"
    ];

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
