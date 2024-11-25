# Nix deployment commands
NIX_CMD = nix
NIX_STORE_CMD = nix-store
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

# nix-darwin
.PHONY: nix-darwin-%
nix-darwin-%:
	@$(DARWIN_REBUILD) switch --flake ".#"${@:nix-darwin-%=%}

# nix-darwin for first deployment
.PHONY: nix-darwin-init-%
nix-darwin-init-%:
	@$(NIX_CMD) build ".#darwinConfigurations."${@:nix-darwin-init-%=%}".system" --verbose --show-trace
	@$(DARWIN_FIRST_BUILD) switch --flake ".#"${@:nix-darwin-init-%=%}

# nix fmt
.PHONY: fmt
fmt:
	@$(NIX_CMD) fmt

# Garbage collection
.PHONY: gc
clean-store:
	@$(NIX_STORE_CMD) --gc

# Test Nix Installation
.PHONY: test
.DEFAULT_GOAL := test
test:
	@$(NIX_CMD) --version

