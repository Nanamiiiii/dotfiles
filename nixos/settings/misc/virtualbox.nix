{ pkgs, username, ... }:
{
  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableWebService = true;
    };
  };

  users.extraGroups.vboxusers.members = [ "${username}" ];
}
