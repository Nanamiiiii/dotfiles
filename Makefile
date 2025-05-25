# Nix deployment commands
NIX_CMD = nix
NIX_STORE_CMD = nix-store
NIXOS_REBUILD = nixos-rebuild

DARWIN_FIRST_BUILD = ./result/sw/bin/darwin-rebuild
DARWIN_REBUILD = darwin-rebuild

# System
OS := $(shell uname -s)
ARCH := $(shell uname -m)

ifeq ($(OS),Linux)
	ifeq ($(ARCH),x86_64)
		SYSTEM := x86_64-linux
	else ifeq ($(ARCH),aarch64)
		$(error Incompatible system: $(SYSTEM))
	endif
else ifeq ($(OS),Darwin)
	SYSTEM := aarch64-darwin
endif

# Location check
# appied for only deployment
RUNS_ENV ?= deployment
EXPECT_LOC = $(shell realpath $(HOME))/dotfiles
ifeq ($(RUNS_ENV),deployment)
	ifneq ($(CURDIR),$(EXPECT_LOC))
		$(error Unexpected location - $(CURDIR). Must locate at ~/dotfiles.)
	endif
endif

# Install Nix
.PHONY: nix-install
nix-install:
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

ifeq ($(SYSTEM), x86_64-linux)

# nixos (build only)
.PHONY: nixos-build-%
nixos-build-%:    
	@$(NIX_CMD) build ".#nixosConfigurations."${@:nixos-build-%=%}".config.system.build.toplevel" --verbose --show-trace --no-link --extra-experimental-features nix-command --extra-experimental-features flakes

# nixos
.PHONY: nixos-%
nixos-%:
	@sudo $(NIXOS_REBUILD) switch --flake ".#"${@:nixos-%=%} 

endif

ifeq ($(SYSTEM), aarch64-darwin)

# nix-darwin for first deployment
.PHONY: nix-darwin-init-%
nix-darwin-init-%:
	@$(NIX_CMD) build ".#darwinConfigurations."${@:nix-darwin-init-%=%}".system" --verbose --show-trace
	@sudo $(DARWIN_FIRST_BUILD) switch --flake ".#"${@:nix-darwin-init-%=%}

# nix-darwin (build only)
.PHONY: nix-darwin-build-%
nix-darwin-build-%:
	@$(NIX_CMD) build ".#darwinConfigurations."${@:nix-darwin-build-%=%}".system" --verbose --show-trace --no-link

# nix-darwin
.PHONY: nix-darwin-%
nix-darwin-%:
	@sudo $(DARWIN_REBUILD) switch --flake ".#"${@:nix-darwin-%=%}

endif

# standalone home-manager (build only)
.PHONY: nix-home-build-%
nix-home-build-%:
	@$(NIX_CMD) run "nixpkgs#home-manager" -- build --no-out-link --debug --show-trace --flake ".#"${@:nix-home-build-%=%}

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
.PHONY: clean-store
clean-store:
	@$(NIX_STORE_CMD) --gc

.PHONY: clean-oldgen
clean-oldgen:
	nix-collect-garbage -d

# Setup Legacy
.PHONY: legacy-install
legacy-install: sheldon-install aqua-install sheldon-link aqua-link legacy-shell tmux-install

# Install Sheldon
.PHONY: sheldon-install
sheldon-install:
	@curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin

# Install aqua
.PHONY: aqua-install
aqua-install:
	curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.0/aqua-installer | bash

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

.PHONY: tmux-install
tmux-install:
	ln -sf $(CURDIR)/config/tmux $(HOME)/.config/
	git clone https://github.com/tmux-plugins/tpm $(HOME)/.config/tmux/plugins/tpm

.PHONY: scripts-link
scripts-link:
	ln -sf $(CURDIR)/config/scripts $(HOME)/.scripts

.PHONY: nvim-install
nvim-install: nvim-build
	ln -sf $(CURDIR)/config/nvim $(HOME)/.config

.PHONY: nvim-build
nvim-build:
	@./config/scripts/build_neovim

# For CI
ifeq ($(RUNS_ENV),ci)
.PHONY: ci-build
ifeq ($(SYSTEM),x86_64-linux)
ci-build:
	@$(NIX_CMD) build --no-link --show-trace --system x86_64-linux --accept-flake-config \
		".#nixosConfigurations.yuki.config.system.build.toplevel" \
		".#nixosConfigurations.mafu.config.system.build.toplevel" \
		".#nixosConfigurations.rika.config.system.build.toplevel"
	@$(NIX_CMD) run "nixpkgs#home-manager" -- build --no-out-link --show-trace --flake ".#xanadu"
else ifeq ($(SYSTEM),aarch64-darwin)
ci-build:
	@$(NIX_CMD) build --show-trace --no-link --system aarch64-darwin --accept-flake-config \
		".#darwinConfigurations.asu.system" 
endif
endif

# Test Nix installation
.PHONY: test
.DEFAULT_GOAL := test
test:
	@$(NIX_CMD) --version
	$(info Detected system: $(SYSTEM))
	$(info Build environment: $(RUNS_ENV))

