{
  pkgs,
  pkgs-stable,
  config,
  hostname,
  ...
}:
let
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
  home.packages = cliPkgs;

  xdg.configFile = with configFiles.dotConfigs; _1password;
}
