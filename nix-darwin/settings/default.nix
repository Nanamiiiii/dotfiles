{
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    ./packages.nix
    ./sops.nix
    inputs.sops-nix.darwinModules.sops
    ./brew.nix
  ];

  nix = {
    settings.trusted-users = [ username ];

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

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
      nerd-fonts.symbols-only
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

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = username;
    stateVersion = 5;
  };
}
