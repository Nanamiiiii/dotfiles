{
  pkgs,
  config,
  desktop,
  inputs,
  hostname,
  ...
}:
let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;

  configFiles = import ../../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };

in
{
  programs = {
    neovide = {
      enable = desktop;
      settings = {
        fork = false;
        frame = "full";
        idle = true;
        maximized = false;
        neovim-bin = "${neovim-nightly}/bin/nvim";
        no-multigrid = false;
        srgb = false;
        tabs = true;
        theme = "auto";
        mouse-cursor-icon = "arrow";
        title-hidden = true;
        vsync = true;
        wsl = false;
        font = {
          normal = [
            "PlemolJP Console NF"
            "Symbols Nerd Font"
          ];
          size = 16.0;
        };
      };
    };
  };

  xdg.configFile = configFiles.dotConfigs.neovim;

  home.packages =
    with pkgs;
    [
      wget
      unzip
    ]
    ++ [
      neovim-nightly
    ];

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
