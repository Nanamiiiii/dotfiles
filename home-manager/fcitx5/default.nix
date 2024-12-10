{ pkgs, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      libskk
      catppuccin-fcitx5
      kdePackages.fcitx5-qt
    ];
  };

  home.file.".xprofile".text = ''
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
  '';

  xdg.configFile."fcitx5/config".source = ./config;
  xdg.configFile."fcitx5/profile".source = ./profile;
  xdg.configFile."fcitx5/conf/skk.conf".source = ./conf/skk.conf;
  xdg.configFile."fcitx5/conf/classicui.conf".source = ./conf/classicui.conf;
}
