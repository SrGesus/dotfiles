{ profiles, inputs, ... }:
{
  imports = with profiles.system; [
    locales
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings.trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
