{config, pkgs, ...}:
{
  home.packages = [
    pkgs.vscode
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
    ];
  };
}
