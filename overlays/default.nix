{ inputs, system, ... }:
{
  nixpkgs.overlays = [
    (import ./zen-browser.nix { inherit inputs system; })
    (import ./ghostty.nix { inherit inputs system; })
    (import ./proton-ge.nix)
  ];
}
