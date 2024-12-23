{ config, username, ... }:
{
  imports = [
    ../../nix-darwin/settings
    ./brew.nix
    ./apps.nix
  ];

  users.users.nanami = {
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
