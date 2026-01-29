{ config, ... }:
{
  flake.homeModules.git =
    { lib, config, ... }:
    let
      cfg = config.modules.git;
      inherit (lib) mkIf mkEnableOption;
    in
    {
      options.modules.git = {
        enable = mkEnableOption "git";
      };

      config.programs.git = mkIf cfg.enable {
        enable = true;

        settings = {
          user.name = "SrGesus";
          user.email = "108523575+SrGesus@users.noreply.github.com";
        };

        lfs.enable = true;
      };

      config.programs.delta = mkIf cfg.enable {
        enable = true;
        enableGitIntegration = true;

        options = {
          features = "decorations";
          line-numbers = true;
          # Workaround for https://github.com/dandavison/delta/issues/1663
          # dark = true;
        };
      };
    };

  commonHomeModules = [
    config.flake.homeModules.git
  ];
}
