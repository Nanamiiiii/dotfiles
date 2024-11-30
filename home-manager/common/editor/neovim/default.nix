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

  skkeletonDicts = {
    "${config.home.homeDirectory}/.skkeleton/dict/SKK-JISYO.L" = {
      source = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
    };
    "${config.home.homeDirectory}/.skkeleton/dict/SKK-JISYO.emoji" = {
      source = "${pkgs.skkDictionaries.emoji}/share/skk/SKK-JISYO.emoji";
    };
    "${config.home.homeDirectory}/.skkeleton/dict/SKK-JISYO.jinmei" = {
      source = "${pkgs.skkDictionaries.emoji}/share/skk/SKK-JISYO.jinmei";
    };
  };
in
{
  programs = {
    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    };
    #neovide = {
    #  enable = desktop;
    #  settings = {
    #    fork = false;
    #    frame = "full";
    #    idle = true;
    #    maximized = false;
    #    neovim-bin = "${pkgs.neovim}/bin/nvim";
    #    no-multigrid = false;
    #    srgb = false;
    #    tabs = true;
    #    theme = "auto";
    #    mouse-cursor-icon = "arrow";
    #    title-hidden = true;
    #    vsync = true;
    #    wsl = false;
    #    font = {
    #      normal = [
    #        "PlemolJP Console NF"
    #        "Symbols Nerd Font"
    #      ];
    #      size = 16.0;
    #    };
    #  };
    #};
  };

  xdg.configFile = configFiles.dotConfigs.neovim;
}
