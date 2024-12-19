# Nix deployment commands
NIX_CMD = nix
NIX_STORE_CMD = nix-store
NIXOS_REBUILD = nixos-rebuild
DARWIN_FIRST_BUILD = ./result/sw/bin/darwin-rebuild
DARWIN_REBUILD = darwin-rebuild

# Variables
AQUA_VERSION = v3.0.1

# Location check
EXPECT_LOC = $(shell realpath $(HOME))/dotfiles
ifneq ($(CURDIR),$(EXPECT_LOC))
$(error Unexpected location - $(CURDIR). Must locate at ~/dotfiles.)
endif

# Install Nix
.PHONY: nix-install
nix-install:
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# nixos (build only)
.PHONY: nixos-build-%
nixos-build-%:    
	@$(NIX_CMD) build ".#nixosConfigurations."${@:nixos-build-%=%}".config.system.build.toplevel" --verbose --show-trace --no-link

# nixos
.PHONY: nixos-%
nixos-%:
	@sudo $(NIXOS_REBUILD) switch --flake ".#"${@:nixos-%=%}

# nix-darwin for first deployment
.PHONY: nix-darwin-init-%
nix-darwin-init-%:
	@$(NIX_CMD) build ".#darwinConfigurations."${@:nix-darwin-init-%=%}".system" --verbose --show-trace
	@$(DARWIN_FIRST_BUILD) switch --flake ".#"${@:nix-darwin-init-%=%}

# nix-darwin (build only)
.PHONY: nix-darwin-build-%
nix-darwin-build-%:
	@$(NIX_CMD) build ".#darwinConfigurations."${@:nix-darwin-build-%=%}".system" --verbose --show-trace --no-link

# nix-darwin
.PHONY: nix-darwin-%
nix-darwin-%:
	@$(DARWIN_REBUILD) switch --flake ".#"${@:nix-darwin-%=%}

# standalone home-manager (build only)
.PHONY: nix-home-build-%
nix-home-build-%:
	@$(NIX_CMD) run "nixpkgs#home-manager" -- build --no-out-link --debug --show-trace --flake ".#"${@:nix-home-%=%}

# standalone home-manager
.PHONY: nix-home-%
nix-home-%:
	@$(NIX_CMD) run "nixpkgs#home-manager" -- -b hm-bkp switch --flake ".#"${@:nix-home-%=%}

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

# Setup Legacy
.PHONY: legacy-install
legacy-install: sheldon-install aqua-install sheldon-link aqua-link legacy-shell

# Install Sheldon
.PHONY: sheldon-install
sheldon-install:
	@curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin

# Install aqua
.PHONY: aqua-install
aqua-install:
	@curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/$(AQUA_VERSION)/aqua-installer | bash

# Symlink to sheldon configurations
.PHONY: sheldon-link
sheldon-link:
	ln -sf $(CURDIR)/sheldon $(HOME)/.config/

# Symlink to aqua configurations
.PHONY: aqua-link
aqua-link:
	ln -sf $(CURDIR)/aqua $(HOME)/.config/

# Symlink to zshrc
.PHONY: lagacy-shell
legacy-shell:
	mkdir -p $(HOME)/.zsh
	echo 'source $$HOME/.zsh/.zshenv' > $(HOME)/.zshenv
	ln -sf $(CURDIR)/config/zsh/.zshenv $(HOME)/.zsh/.zshenv
	ln -sf $(CURDIR)/config/zsh/.zprofile $(HOME)/.zsh/.zprofile
	ln -sf $(CURDIR)/config/zsh/.zshrc $(HOME)/.zsh/.zshrc
	ln -sf $(CURDIR)/config/starship/starship.toml $(HOME)/.config/starship.toml

.PHONY: scripts-link
scripts-link:
	ln -sf $(CURDIR)/config/scripts $(HOME)/.scripts

.PHONY: nvim-install
nvim-install:
	@./config/scripts/build_neovim

# Test Nix installation
.PHONY: test
.DEFAULT_GOAL := test
test:
	@$(NIX_CMD) --version

