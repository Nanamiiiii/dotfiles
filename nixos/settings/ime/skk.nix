{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-skk
        # fcitx5-tokyonight
        catppuccin-fcitx5
        qt6Packages.fcitx5-configtool
      ];
      waylandFrontend = true;
    };
  };
}
