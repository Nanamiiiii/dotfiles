FROM nixos/nix:latest

RUN nix-channel --update

RUN nix-env -iA nixpkgs.gnumake

