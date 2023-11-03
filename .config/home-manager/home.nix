{pkgs, ...}: {
  home.username = "user";
  home.homeDirectory = "/home/user";
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";

  imports = [
    ./vscode.nix
    ./git.nix
    ./librewolf.nix
    ./cli-tools.nix
    ./games.nix
    ./gtk.nix
    ./documents.nix
  ];

  home.packages = with pkgs; [
    vim
    discord
    neofetch
    guake
    gparted
  ];
}
