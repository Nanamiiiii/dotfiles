{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    spaceship-prompt
  ];

  xdg.configFile."spaceship" = {
    source = ../../../../config/spaceship;
    recursive = true;
  };

  programs.zsh = {
    enable = true;

    initContent = ''
      for section_file in ${config.xdg.configHome}/spaceship/sections/*.zsh(N); do
        source "$section_file"
      done

      source ${pkgs.spaceship-prompt}/share/zsh/themes/spaceship.zsh-theme
    '';
  };
}
