{config, pkgs, ...}:
{
  home.packages = [
    pkgs.vscode
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      redhat.java
      jnoortheen.nix-ide
    ];
    userSettings = {
      "java.jdt.ls.java.home" = "${pkgs.jdk17}/lib/openjdk";
      "terminal.integrated.fontFamily" = ["Iosevka Nerd Font"];
    };
  };
}
