{ ... }:
{
  nixpkgs.overlays = [
    (import ./zen-browser-specific.nix)
  ];
}
