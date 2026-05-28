{ username, ... }:
{
  nix = {
    settings.trusted-users = [ username ];

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

}
