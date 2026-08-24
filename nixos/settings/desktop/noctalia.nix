{ lib, ... }:
{
  security.pam.services.login = {
    fprintAuth = lib.mkForce true;
    unixAuth = true;
  };
}
