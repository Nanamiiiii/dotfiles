{ lib, ... }:
{
  kvantumConf = lib.generators.toINI { } {
    "General" = {
      theme = "catppuccin-mocha-blue";
    };
  };
}
