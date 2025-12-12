{
  pkgs,
  lib,
  inputs,
  username,
  ...
}:
{
  imports = [
    ./packages.nix
    ./sops.nix
    ./brew.nix
    ./security.nix
    inputs.sops-nix.darwinModules.sops
  ];

  nix = {
    settings.trusted-users = [ username ];

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    zsh.enable = true;
  };

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

  system = {
    primaryUser = username;
    defaults = {
      NSGlobalDomain.AppleShowAllExtensions = true;
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        NewWindowTarget = "Home";
      };
      dock = {
        autohide = false;
        show-recents = false;
        orientation = "right";
      };
    };
    stateVersion = 5;
  };
}
