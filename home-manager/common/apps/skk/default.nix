{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    skkDictionaries.l
    skkDictionaries.emoji
    skkDictionaries.jinmei
    skkDictionaries.fullname
    skkDictionaries.propernoun
    skkDictionaries.jis2
    skkDictionaries.jis3_4
    skkDictionaries.jis2004
  ];
}
