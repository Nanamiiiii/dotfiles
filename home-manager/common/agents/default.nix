{ pkgs, lib, ... }:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;
in
{
  home.packages =
    with pkgs.llm-agents;
    [
      claude-code
      codex
    ]
    ++ lib.optional (baseSystem == "linux") pkgs.llm-agents.claude-desktop;
}
