{ pkgs, username, ... }:
{
  users = {
    users."myuutwo" = {
      description = "Akihiro Saiki";
      uid = 1979;
      isNormalUser = true;
      shell = pkgs.zsh;
      group = "supercom";
    };

    groups."supercom" = {
      gid = 1500;
    };
  };
}
