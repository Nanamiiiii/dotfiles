{ config, username, ... }:
{
  imports = [
    ../../nix-darwin/settings
    ./apps.nix
    ./brew.nix
    ./security.nix
  ];

  users.users.${username} = {
    home = "/Users/${username}";
  };

  networking = {
    hostName = "asu";
  };

  services.cachix-agent = {
    enable = true;
    name = "asu";
    credentialsFile = config.sops.secrets.cachix-agent.path;
  };

  sops.secrets.cachix-agent = {
    sopsFile = ./secrets.yaml;
  };
}
