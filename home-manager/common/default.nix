{ ... }:
{
  imports = [
    ./apps
    ./cli
    ./editor
    ./lang
    ./shell
    ./terminal
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;
}
