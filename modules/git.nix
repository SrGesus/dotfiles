{ lib, config, ... }: let
  cfg = config.modules.home-manager;
in {

  # options.modules.git = {
  #   enable = lib.mkEnableOption "git module";
  #   safeDirs = lib.mkEnableOption "marking all directories as safe in git";
  #   delta.enable = lib.mkEnableOption "git delta";
  # };

  # config = lib.mkIf cfg.enable {

  config.home-manager.users = lib.mapAttrs (user: value: lib.mkIf value.git.enable {
    programs.git = {
    enable = true;
    userName = "SrGesus";
    userEmail = "108523575+SrGesus@users.noreply.github.com";
    extraConfig = {
      safe.directory = lib.mkIf (false && value.git.safeDirs) "*";
    };
    delta = lib.mkIf (false && value.git.delta.enable) {
      enable = true;
      options = {
        features = "decorations";
        line-numbers = true;
        # Workaround for https://github.com/dandavison/delta/issues/1663
        # dark = true;
      };
    };
    };}
  ) cfg;
}
