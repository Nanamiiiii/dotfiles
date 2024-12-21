{ ... }:
{
  nixpkgs.overlays = [
    (import ./zen-browser-specific.nix)
    (import ./proton-ge.nix)
  ];
}
