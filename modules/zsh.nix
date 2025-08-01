{ lib, config, ... }:
let
  cfg = config.modules.zsh;
in
{
  options.modules.zsh = {
    enable = lib.mkEnableOption "zsh";
    enableEza = lib.mkOption {
      default = cfg.enable;
      example = true;
      description = "Whether to enable eza.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          # "docker-compose"
          "fzf"
        ];
      };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
    };

    # programs.eza = lib.mkIf cfg.enableEza {
    #   enable = true;
    #   enableZshIntegration = true;
    # };
  };
}
