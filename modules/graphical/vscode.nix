{ config, ... }:
{
  flake.homeModules.vscode =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        profiles.default.extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          vscodevim.vim
        ];
      };

      home.packages = [
        pkgs.nixfmt
        pkgs.nixd
      ];
    };

}
