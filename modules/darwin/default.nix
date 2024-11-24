{ pkgs, username, ... }:
{
  imports = [ ./brew.nix ];

  nix.settings.trusted-users = [ username ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  environment.variables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
  };

  fonts = {
    packages = with pkgs; [
      plemoljp
      plemoljp-nf
      plemoljp-hs
      ibm-plex
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      (noto-fonts.override {
        variants = [
          "NotoSansSymbols"
          "NotoSansSymbols2"
        ];
      })
    ];
  };

  time.timeZone = "Asia/Tokyo";

  system.stateVersion = 5;

  homebrew.enable = true;
}
