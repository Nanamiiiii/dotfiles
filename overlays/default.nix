{ inputs, system, ... }:
{
  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];
}
