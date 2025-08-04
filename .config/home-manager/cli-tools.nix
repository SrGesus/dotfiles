{config, pkgs, lib, ...}:
{
  home.packages = with pkgs; [
    zsh
    bat
    ripgrep
    eza
    zsh-powerlevel10k
    gnumake
    btop
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
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
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