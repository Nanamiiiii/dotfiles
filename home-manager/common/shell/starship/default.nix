{
  programs = {
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ../../../../config/starship/starship.toml);
    };
  };
}
