{ config, inputs, ... }:
{
  flake.nixosModules.cachyos-kernel =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;
    };
}
