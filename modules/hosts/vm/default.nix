{ config, pkgs, ... }:
{
  hosts.vm = {
    system = "x86_64-linux";
    modules = with config.flake.nixosModules; [
      sshd
      vim
      vps
      {
        users.users.user = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
        };

        home-manager.users.user = {
          modules = {
            superuser = true;
            isNormalUser = true;
          };

          home.stateVersion = "26.05";
        };

        users.users.user = {
          initialPassword = "banana";
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPO1/Mg1Q33F7J3k2A3sziZKeOZT1Cp9ODlYGbDA9HZ user@versailles"
          ];
        };

        security.sudo.wheelNeedsPassword = false;

        # Configure console keymap
        console.keyMap = "pt-latin1";
        networking.useDHCP = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        system.stateVersion = "26.05";
      }
    ];
  };
}
