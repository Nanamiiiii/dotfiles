{
  pkgs,
  config,
  lib,
  ...
}:
{
  users.ldap = {
    enable = true;
    loginPam = false;
    nsswitch = false;
    server = "ldap://133.9.80.141/ ldap://133.9.80.30/ ldap://133.9.80.130/";
    base = "dc=oscar,dc=elec,dc=waseda,dc=ac,dc=jp";
    daemon = {
      enable = true;
    };
    bind = {
      distinguishedName = "cn=admin,dc=oscar,dc=elec,dc=waseda,dc=ac,dc=jp";
      passwordFile = config.sops.secrets.lab-ldap-passwd.path;
    };
  };

  system.nssModules = lib.singleton pkgs.nss_pam_ldapd;

  system.nssDatabases.hosts = [ "ldap" ];

  sops.secrets.lab-ldap-passwd = {
    mode = "0400";
    owner = config.users.users.nslcd.name;
    group = config.users.users.nslcd.group;
  };
}
