{ lib, ... }:
{
  kvantumConf = lib.generators.toINI { } {
    "General" = {
      theme = "Catppuccin-Mocha-Lavender";
    };
  };
}
