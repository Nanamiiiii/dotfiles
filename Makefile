# Nix deployment commands
NIX_CMD = nix
NIX_STORE_CMD = nix-store
NIXOS_REBUILD = nixos-rebuild
DARWIN_FIRST_BUILD = ./result/sw/bin/darwin-rebuild
DARWIN_REBUILD = darwin-rebuild

# Location check
EXPECT_LOC = $(HOME)/dotfiles
ifneq ($(CURDIR),$(EXPECT_LOC))
$(error Unexpected location. Must locate at ~/dotfiles)
endif

# Install Nix
.PHONY: nix-install
nix-install:
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# nixos
.PHONY: nixos-%
nixos-%:
	@sudo $(NIXOS_REBUILD) switch --flake ".#"${@:nixos-%=%}

# nixos (build only)
.PHONY: nixos-build-%
nixos-build-%:    
	@$(NIX_CMD) build ".#nixosConfigurations."${@:nixos-build-%=%}".config.system.build.toplevel" --verbose --show-trace --no-link

# nix-darwin
.PHONY: nix-darwin-%
nix-darwin-%:
	@$(DARWIN_REBUILD) switch --flake ".#"${@:nix-darwin-%=%}

# nix-darwin for first deployment
.PHONY: nix-darwin-init-%
nix-darwin-init-%:
	@$(NIX_CMD) build ".#darwinConfigurations."${@:nix-darwin-init-%=%}".system" --verbose --show-trace
	@$(DARWIN_FIRST_BUILD) switch --flake ".#"${@:nix-darwin-init-%=%}

# Update
.PHONY: update
update:
	@$(NIX_CMD) flake update

# nix fmt
.PHONY: fmt
fmt:
	@$(NIX_CMD) fmt

# Garbage collection
.PHONY: gc
clean-store:
	@$(NIX_STORE_CMD) --gc

# Test Nix installation
.PHONY: test
.DEFAULT_GOAL := test
test:
	@$(NIX_CMD) --version

