NIX_CMD = nix
DARWIN_FIRST_BUILD = ./result/sw/bin/darwin-rebuild
DARWIN_REBUILD = darwin-rebuild

.PHONY: nix-install
nix-install:
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

.PHONY: nix-darwin-%
nix-darwin-%:
	@$(DARWIN_REBUILD) switch --flake ".#"${@:nix-darwin-%=%}

.PHONY: nix-darwin-init-%
nix-darwin-init-%:
	@$(NIX_CMD) build ".#darwinConfigurations."${@:nix-darwin-init-%=%}".system" --verbose --show-trace
	@$(DARWIN_FIRST_BUILD) switch --flake ".#"${@:nix-darwin-init-%=%}

.PHONY: fmt
fmt:
	@$(NIX_CMD) fmt

