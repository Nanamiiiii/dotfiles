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
  ];
}
