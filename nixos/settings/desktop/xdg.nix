{ pkgs, ... }:
{
  xdg = {
    portal = {
      enable = true;
    };
  };
  services.flatpak.enable = true;
}
