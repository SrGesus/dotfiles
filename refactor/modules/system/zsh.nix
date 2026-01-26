{ lib, config, pkgs, ... }:
let inherit (lib) mkIf attrValues any;
in {
  # Enable zsh system wide if any user has zsh module enabled
  programs.zsh.enable = any (value: value.modules.zsh.enable)
    (attrValues config.home-manager.users);

  # If zsh home-module is defined, set zsh as user shell for that user.
  users.users = builtins.mapAttrs
    (name: value: mkIf value.modules.zsh.enable { shell = pkgs.zsh; })
    config.home-manager.users;
}
