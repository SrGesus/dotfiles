{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.nixosModules.laptop =
    { pkgs, ... }:
    {

      imports = with config.flake.nixosModules; [
        firefox
        printing
        tailscale
      ];

      services.resolved = {
        enable = true;
        dnssec = "true"; # Or "allow-downgrade"
      };

      networking = {
        # Configure network proxy if necessary
        # proxy.default = "http://user:password@proxy:port/";
        # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

        # Set trusted DNS servers
        nameservers = [
          "1.1.1.1"
          "1.0.0.1"
        ];

        useDHCP = lib.mkDefault true;

        networkmanager = {
          enable = true;
          dns = lib.mkForce "none";
          plugins = [ pkgs.networkmanager-openvpn ];
        };
      };
    };
}
