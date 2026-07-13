{ inputs, ... }:
{
  # only for x86_64
  home.packages = [
    inputs.claude-desktop.packages.x86_64-linux.default
  ];
}
