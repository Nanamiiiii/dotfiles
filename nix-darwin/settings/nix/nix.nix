{ username, ... }:
{
  nix = {
    settings.trusted-users = [ username ];

    extraOptions = ''
      experimental-features = nix-command flakes
      extra-substituters = https://nix-cache.myuu.dev/systems https://nix-cache.myuu.dev/packages
      extra-trusted-public-keys = nix-cache.myuu.dev-1:2lAuxMiua4hEYRgGu3JXHafpZrHprrQi+TmrQIKJ6+E=
    '';
  };

}
