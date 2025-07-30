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
  ];

  networking.hostName = "graz";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  services.openssh.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  #services.desktopManager.plasma6-bigscreen.enable = true;

  # Timezone
  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";

    # Pt Keyboard
    keyMap = lib.mkForce "pt-latin9";
    #keyMap = "pt";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.xserver = {
    enable = true;
    xkb.layout = "pt";
    # xkb.options = "eurosign:e,caps:escape";
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
    iwd
    man
    fastfetch
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
