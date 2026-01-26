{
  config,
  pkgs,
  profiles,
  ...
}:

{
  imports = with profiles.system; [
    # Include the results of the hardware scan.
    firefox
    graphical
    locale
    networking
    printing
    ./hardware.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # modules = {

  # };

  home-manager.users.user = {
    imports = with profiles.home; [
    ];

    modules = {
      superuser = true;
      isNormalUser = true;
    };

    home.stateVersion = "25.11";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pt";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pt-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.user = {
  #   description = "User";
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
