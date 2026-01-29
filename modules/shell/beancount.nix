{ ... }:
{
  flake.homeModules.beancount =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        beancount
        fava
        beanprice
      ];
    };
}
