{ config, ... }:
{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age = {
      keyFile = "${config.home.homeDirectory}/.age-key.txt";
      generateKey = true;
    };
  };
}
