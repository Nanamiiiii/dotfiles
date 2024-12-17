{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  programs.stylua = {
    enable = true;
    includes = [
      "config/nvim/**/*.lua"
      "config/wezterm/*.lua"
    ];
    settings = {
      indent_type = "Spaces";
      indent_width = 4;
      column_width = 120;
      sort_requires.enabled = true;
    };
  };
}
