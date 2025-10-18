{ lib, config, ... }: let
  cfg = config.modules.git;
  inherit (lib) mkIf mkEnableOption;
in {
  options.modules.git = {
    enable = mkEnableOption "git";
    # delta = mkEnableOption "git delta";
  };

  config.programs.git = mkIf cfg.enable {
    enable = true;
    
    userName = "SrGesus";
    userEmail = "108523575+SrGesus@users.noreply.github.com";

    delta = {
      enable = true;
        options = {
          features = "decorations";
          line-numbers = true;
          # Workaround for https://github.com/dandavison/delta/issues/1663
          # dark = true;
        };
    };

    lfs.enable = true;
  };
}
