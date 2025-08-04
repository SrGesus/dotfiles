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
        historySubstringSearch.enable = true;
        enableCompletion = true;

        initContent = ''
          [[ $- == *i* ]] && fastfetch
        '';

        shellAliases = {
          cat = "batcat";
          eza = lib.mkIf value.zsh.enableEza "eza --icons";
          ls = lib.mkIf value.zsh.enableEza "eza";
          tree = lib.mkIf value.zsh.enableEza "eza -T";
        };
      };

      programs.fastfetch.enable = true;

      programs.bat.enable = true;



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
}
