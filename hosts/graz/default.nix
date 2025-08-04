{
  config,
  lib,
  pkgs,
  nixos-raspberrypi,
  ...
}:
{
  imports = [
    ./hardware.nix
    nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
  ];

  networking.hostName = "graz";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  services.openssh.enable = true;

  services.tailscale.enable = true;

  services.displayManager = {
    autoLogin.user = "pi";
    sddm.enable = true;
    sddm.wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  #services.desktopManager.plasma6-bigscreen.enable = true;

  # Locale
  i18n.defaultLocale = "en_IE.UTF-8";

  services.xserver.enable = true;

  modules = {
    home-manager.pi = {
      git.enable = true;
      zsh.enable = true;
      enable = true;
    };
  };

  # Enable CUPS to print documents
  # services.printing.enable = true;

  # Enable sounds.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire.enable = true;
  # services.pipewire.pulse.enable = true;

  environment.systemPackages = with pkgs; [
    helix
    eza
    ripgrep
    man
    fastfetch
    firefox
  ];

  # user
  users.users.pi = {
    initialPassword = "banana";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings.trusted-users = [
    "root"
    "pi"
  ];

  system.stateVersion = "25.05";
}
