{ username, ... }:
{
  services.openssh = {
    enable = true;
  };

  users.users.${username}.openssh = {
    authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgj6Btmt4+mNgb6fCDYbmqW7IM0sN8X8+RuAw1UQjdm"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDjjJaYz3a6f6QRWh/NK7U3o6Pj1fWKj7hc1VSW8rde"
      ];
    };
  };
}
