{
  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
