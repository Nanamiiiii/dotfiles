{
  # 1Password Custom Browser
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      zen-bin
      vivaldi-bin
      floorp
    '';
    mode = "0755";
  };
}