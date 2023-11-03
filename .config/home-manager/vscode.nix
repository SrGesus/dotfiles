{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    vscode

    python3
    gcc
    arduino
    arduino-cli avrdude
    platformio
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
      "terminal.integrated.fontFamily" = "Iosevka Nerd Font";
      "window.zoomLevel" = 1;
      # "platformio-ide.useBuiltinPIOCore" = false;
      # "platformio-ide.customPATH" = "${pkgs.platformio}/bin";
    };
  };
}
