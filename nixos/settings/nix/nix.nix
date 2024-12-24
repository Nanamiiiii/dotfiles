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
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

  };
}
