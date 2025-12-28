{ config, ... }:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file.".face.icon".source = ../../../assets/avatar.png;
  home.file.".face".source = symlink "${config.home.homeDirectory}/.face.icon";
}
