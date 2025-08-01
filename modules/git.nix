{ lib, config, ... }: let
  cfg = config.modules.git;
in {

  options.modules.git = {
    enable = lib.mkEnableOption "git module";
    safeDirs = lib.mkEnableOption "marking all directories as safe in git";
    delta.enable = lib.mkEnableOption "git delta";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "SrGesus";
      userEmail = "108523575+SrGesus@users.noreply.github.com";
      extraConfig = {
        safe.directory = lib.mkIf cfg.safeDirs "*";
      };
      delta = lib.mkIf cfg.delta.enable {
        enable = true;
        options = {
          features = "decorations";
          line-numbers = true;
          # Workaround for https://github.com/dandavison/delta/issues/1663
          # dark = true;
        };
      }
    };
  }
}
