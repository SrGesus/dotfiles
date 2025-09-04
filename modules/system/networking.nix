{ pkgs, ... }: {
  services.tailscale.enable = true;

  boot.kernelPatches = [
    # Fix the /proc/net/tcp seek issue
    # Impacts tailscale: https://github.com/tailscale/tailscale/issues/16966
    {
      name = "proc: fix missing pde_set_flags() for net proc files";
      patch = pkgs.fetchurl {
        name = "fix-missing-pde_set_flags-for-net-proc-files.patch";
        url =
          "https://patchwork.kernel.org/project/linux-fsdevel/patch/20250821105806.1453833-1-wangzijie1@honor.com/raw/";
        hash = "sha256-DbQ8FiRj65B28zP0xxg6LvW5ocEH8AHOqaRbYZOTDXg=";
      };
    }
  ];
}
