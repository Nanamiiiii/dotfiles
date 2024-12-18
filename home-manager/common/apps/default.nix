{
  pkgs,
  pkgs-stable,
  config,
  desktop,
  hostname,
  ...
}:
let
  desktopPkgs = with pkgs; [
    discord
    obsidian
    zotero
  ];

  cliPkgs = with pkgs; [
    skkDictionaries.l
    skkDictionaries.emoji
    skkDictionaries.jinmei
    skkDictionaries.fullname
    skkDictionaries.propernoun
    skkDictionaries.jis2
    skkDictionaries.jis3_4
    skkDictionaries.jis2004
  ];

  configFiles = import ../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };
in
{
  home.packages = if desktop then desktopPkgs ++ cliPkgs else cliPkgs;

  xdg.configFile = with configFiles.dotConfigs; _1password;
}
