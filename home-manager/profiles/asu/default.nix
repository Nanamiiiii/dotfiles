{ ... }:
{
  imports = [
    ../../common
    ../../darwin
    ../../sops
    ./config.nix
  ];

  home.stateVersion = "25.05";
}
