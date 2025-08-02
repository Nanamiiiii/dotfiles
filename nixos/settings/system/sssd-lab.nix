{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.sssd = {
    enable = true;
    config = ''
      [sssd]
      config_file_version = 2
      domains = kasahara.cs.waseda.ac.jp
      services = nss, pam, autofs

      [nss]
      filter_groups = root
      filter_users = root

      [pam]

      [domain/kasahara.cs.waseda.ac.jp]
      id_provider = ldap
      auth_provider = ldap
      chpass_provider = ldap
      sudo_provider = ldap
      autofs_provider = ldap

      ldap_uri = ldap://192.168.50.18

      ldap_search_base = dc=oscar,dc=elec,dc=waseda,dc=ac,dc=jp

      ldap_tls_reqcert = never
      ldap_id_use_start_tls = False
      ldap_search_timeout = 3
      ldap_network_timeout = 3
      ldap_opt_timeout = 3

      enumerate = True
      ldap_enumeration_search_timeout = 60
      ldap_enumeration_refresh_timeout = 300
      ldap_connection_expire_timeout = 600

      entry_cache_timeout = 1200
      cache_credentials = True

      ldap_autofs_search_base = ou=automount,dc=oscar,dc=elec,dc=waseda,dc=ac,dc=jp
      ldap_autofs_map_object_class = automountMap
      ldap_autofs_entry_object_class = automount
      ldap_autofs_map_name = automountMapName
      ldap_autofs_entry_key = automountKey
      ldap_autofs_entry_value = automountInformation

      ldap_iphost_search_base = ou=Hosts,dc=oscar,dc=elec,dc=waseda,dc=ac,dc=jp

      [autofs]
    '';
  };
}
