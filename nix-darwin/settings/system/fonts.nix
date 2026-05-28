{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      plemoljp
      plemoljp-nf
      plemoljp-hs
      ibm-plex
      nerd-fonts.symbols-only
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      (noto-fonts.override {
        variants = [
          "NotoSansSymbols"
          "NotoSansSymbols2"
        ];
      })
      biz-ud-gothic
    ];
  };
}
