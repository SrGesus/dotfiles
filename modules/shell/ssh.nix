{ ... }:
{
  flake.nixosModules.sshd = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        # PermitRootLogin = "no";
        # AllowUsers = [ "user" ];
      };
    };
  };
}
