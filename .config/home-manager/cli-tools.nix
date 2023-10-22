{config, pkgs, lib, ...}:
{
  home.packages = with pkgs; [
    zsh
    bat
    ripgrep
    eza
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./.;
        file = "p10k.zsh";
      }
    ];
    

    shellAliases = {
      dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
      cat="bat";
      grep="rg";
      ls="eza";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

  };
}