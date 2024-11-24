{
  # neovim
  vi = "nvim";
  vim = "nvim";

  # rm / cp
  rm = "rm -i";
  cp = "cp -i";

  # eza
  ls = "eza --icons --group-directories-first";
  la = "eza --icons --group-directories-first -a";
  ll = "eza --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso";
  tree = "eza --group-directories-first -T --icons";

  # bat
  cat = "bat --style=plain --paging=never";
  less = "bat --style=plain";

  # fd
  find = "fd";

  # dust
  du = "dust";
  dus = "dust --depth=1";

  # procs
  ps = "procs";
  ptree = "procs --tree";

  # duf
  df = "duf";

  # lazygit
  lg = "lazygit";
}
