{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.home-manager;
  in
{
  options.modules.home-manager = lib.mapAttrs (user: set: {
    zsh = {
      enable = lib.mkEnableOption "zsh";
      enableEza = lib.mkOption {
        default = true;
        example = false;
        description = "Whether to enable eza.";
        type = lib.types.bool;
      };
    };
  }) config.users.users;

  # Enable zsh system wide if any user has zsh module enabled
  config.programs.zsh.enable = lib.any (value: value.zsh.enable) (lib.attrValues cfg);

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
            "zoxide"
          ];
        };

        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;

        shellAliases = {
          cat = "bat";
          eza = lib.mkIf value.zsh.enableEza "eza --icons";
          ls = lib.mkIf value.zsh.enableEza "eza";
          tree = lib.mkIf value.zsh.enableEza "eza -T";
        };
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.eza = lib.mkIf value.zsh.enableEza {
        enable = true;
        enableZshIntegration = true;
      };

    }
  ) cfg;

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
