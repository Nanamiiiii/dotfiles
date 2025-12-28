{
  username,
  avatar ? ../../../assets/avatar.png,
  ...
}:
{
  services.accounts-daemon.enable = true;

  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/icons
    cp ${avatar} /var/lib/AccountsService/icons/${username}

    mkdir -p /var/lib/AccountsService/users

    echo "[User]
    SystemAccount=false
    Icon=/var/lib/AccountsService/icons/${username}" > /var/lib/AccountsService/users/${username}
  '';
}
