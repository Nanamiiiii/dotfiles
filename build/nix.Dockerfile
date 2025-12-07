FROM nixos/nix:latest

RUN nix-channel --update

RUN nix-env -iA nixpkgs.gnumake

RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

WORKDIR /work

COPY . .

