{ lib, config, ... }:
{
  options.modules.home-manager = lib.mapAttrs (user: set: {
    zsh = {
      enable = lib.mkEnableOption "zsh";
      enableEza = lib.mkOption {
        default = true;
        example = true;
        description = "Whether to enable eza.";
        type = lib.types.bool;
      };
    };
  }) config.users.users;

  config.home-manager.users = lib.mapAttrs (
    user: value:
    lib.mkIf value.zsh.enable {
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

    programs.eza = lib.mkIf value.zsh.enableEza {
      enable = true;
      enableZshIntegration = true;
    };
      
    }
  ) config.modules.home-manager;

  # config = lib.mkIf cfg.enable {
  #   programs.zsh = {
  #     enable = true;

  #     oh-my-zsh = {
  #       enable = true;
  #       plugins = [
  #         "git"
  #         # "docker-compose"
  #         "fzf"
  #       ];
  #     };

  #     autosuggestions.enable = true;
  #     syntaxHighlighting.enable = true;
  #     enableCompletion = true;
  #   };

  #   # programs.eza = lib.mkIf cfg.enableEza {
  #   #   enable = true;
  #   #   enableZshIntegration = true;
  #   # };
  # };
}
