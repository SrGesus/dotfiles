{
  flake.nixosModules.vim =
    { pkgs, ... }:
    {
      programs.vim = {
        enable = true;
        package = pkgs.vim-full;
        defaultEditor = true;
      };
    };
}
