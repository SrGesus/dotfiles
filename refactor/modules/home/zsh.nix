{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.zsh;
in
{
  options.modules = {
    zsh = {
      enable = lib.mkEnableOption "zsh";
      enableEza = lib.mkOption {
        default = true;
        example = false;
        description = "Whether to enable eza.";
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    programs.direnv.enable = true;
    programs.direnv.enableZshIntegration = true;

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

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      enableCompletion = true;

      initContent = ''
        bindkey '^H' backward-kill-word
        
        function git_branch(){
            ref=$(git symbolic-ref --short --quiet HEAD 2>/dev/null)
            if [ -n "''${ref}" ]; then
                echo " %{%F{green}%}(""$ref"")"
            fi
        }

        [ ''${ZSH_VERSION} ] && precmd() { export retval=$?; }

        [[ $SHLVL -eq 1 ]] && [[ $- == *i* ]] && ${config.programs.fastfetch.package}/bin/fastfetch

        NEWLINE=$'\n'
        PROMPT="''${NEWLINE}%{$(tput setaf 15 bold)%}%D{%a %d %b %Y %T} %{$(tput setaf 2)%}%M%{$(tput sgr0)%} [%!]\$(git_branch)%{%F{none}%}\$([[ \$retval -ne 0 ]] && echo \" Exited with \$retval.\")''${NEWLINE}%{$(tput setaf 2 bold)%}%n@%m %{$(tput setaf 4)%}%~%{$(tput sgr0)%} %#$([[ $SHLVL -ne 1 ]] && echo "$SHLVL")> "
      '';

      shellAliases = {
        cat = "bat";
        eza = lib.mkIf cfg.enableEza "eza --icons=auto";
        ls = lib.mkIf cfg.enableEza "eza";
        d = lib.mkIf cfg.enableEza "eza -alF";
        tree = lib.mkIf cfg.enableEza "eza -T";
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
      options = [
        "--cmd cd"
      ];
    };

    programs.eza = lib.mkIf cfg.enableEza {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zellij = {
      enable = true;
      # enableZshIntegration = true;
      # attachExistingSession = true;
      # exitShellOnExit = true;
    };

    home.file = {
      "${config.xdg.configHome}/zellij/config.kdl" = {
        source = ../../.config/zellij/config.kdl;
      };
    };

    home.packages = with pkgs; [
      devenv
    ];
  };
}
