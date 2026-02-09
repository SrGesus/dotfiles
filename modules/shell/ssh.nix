{ ... }:
{
  flake.nixosModules.sshd = {
    services.openssh = {
      enable = true;
      ports = [ 35422 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        # PermitRootLogin = "no";
        # AllowUsers = [ "user" ];
      };
    };

    services.endlessh = {
      enable = true;
      port = 22;
      openFirewall = true;
    };
  };
}
