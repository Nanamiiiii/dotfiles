{ ... }:
{
  imports = [
    ./apps
    ./cli
    ./editor
    ./lang
    ./shell
    ./terminal
    ./nix
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;
}
