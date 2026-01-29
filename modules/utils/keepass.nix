{
  flake.homeModules.keepass = {
    programs.keepassxc = {
      enable = true;
      autostart = true;
    };
  };
}
