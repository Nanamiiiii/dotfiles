{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
  };
}
