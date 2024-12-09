{
  pkgs,
  config,
  desktop,
  inputs,
  osConfig,
  ...
}:
let
  configFiles = import ../../../../config {
    inherit
      pkgs
      config
      osConfig
      ;
  };

in
{
  programs = {
    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    };
  };

  xdg.configFile = configFiles.dotConfigs.neovim;

  home.file.".skkeleton/dict/SKK-JISYO.L" = {
    source = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
  };
  home.file.".skkeleton/dict/SKK-JISYO.emoji" = {
    source = "${pkgs.skkDictionaries.emoji}/share/skk/SKK-JISYO.emoji";
  };
  home.file.".skkeleton/dict/SKK-JISYO.jinmei" = {
    source = "${pkgs.skkDictionaries.jinmei}/share/skk/SKK-JISYO.jinmei";
  };
}
