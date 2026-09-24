{ username, ... }:
{
  nix = {
    checkConfig = true;

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "${username}" ];
      extra-substituters = [
        "https://nix-cache.myuu.dev/systems"
        "https://nix-cache.myuu.dev/packages"
      ];
      extra-trusted-public-keys = [
        "nix-cache.myuu.dev-1:2lAuxMiua4hEYRgGu3JXHafpZrHprrQi+TmrQIKJ6+E="
      ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
