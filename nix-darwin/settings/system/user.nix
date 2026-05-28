{ username, ... }:
{
  users.users.${username} = {
    home = "/Users/${username}";
  };
}
