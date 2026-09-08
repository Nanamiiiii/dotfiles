{
  pkgs,
  lib,
  config,
  ...
}:
let
  socklink = pkgs.callPackage ./package.nix { };
  socklinkBin = "${socklink}/bin/socklink.sh";

  hasClientActiveHook = lib.versionAtLeast config.programs.tmux.package.version "3.3";
in
{
  home.packages = [ socklink ];

  programs.zsh.initContent = lib.mkOrder 1600 ''
    if [[ -o interactive ]]; then
      if [[ -z "$TMUX" ]]; then
        if [[ -t 0 ]]; then
          ${socklinkBin} -c shell-init set-tty-link || true
        fi
      else
        _socklink_link="$(${socklinkBin} show-server-link)"
        if [[ -L "$_socklink_link" ]] ||
           [[ -n "$_socklink_link" && ! -e "$SSH_AUTH_SOCK" ]]; then
          export SSH_AUTH_SOCK="$_socklink_link"
        fi
        unset _socklink_link
      fi
    fi
    true
  '';

  programs.tmux.extraConfig = lib.mkAfter (
    lib.optionalString hasClientActiveHook ''
      set-hook -g client-active 'run-shell "${socklinkBin} -c client-active set-server-link-by-name \"#{hook_client}\""'
    ''
    + ''
      set-hook -g client-attached 'run-shell "${socklinkBin} -c client-attached set-server-link \"#{client_tty}\""'
      set-hook -g session-created 'run-shell "${socklinkBin} -c session-created set-server-link \"#{client_tty}\""'
      set-hook -ga session-created 'run-shell "${socklinkBin} -c session-created set-tmux-env"'
    ''
  );
}
