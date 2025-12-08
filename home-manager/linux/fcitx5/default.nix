{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      libskk
      catppuccin-fcitx5
      kdePackages.fcitx5-qt
    ];
    fcitx5.waylandFrontend = true;
  };

  xdg.configFile."fcitx5/config".source = ./config;
  xdg.configFile."fcitx5/profile" = {
    source = ./profile;
    force = true;
  };
  xdg.configFile."fcitx5/conf/skk.conf".source = ./conf/skk.conf;
  xdg.configFile."fcitx5/conf/classicui.conf".source = ./conf/classicui.conf;
}
