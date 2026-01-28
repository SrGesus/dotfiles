{ ... }:
{
  flake.nixosModules.tailscale = {
    services.tailscale = {
      enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };
  };
}
