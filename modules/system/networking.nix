{ pkgs, lib, ... }: {
  services.tailscale.enable = true;

  services.resolved.enable = true;
  services.resolved.dnssec = "true"; # Or "allow-downgrade"
  # Optional: Set trusted DNS servers
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.networkmanager.dns = lib.mkForce "none";
}
