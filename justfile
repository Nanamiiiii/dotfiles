# Nix deployment commands
set quiet

NIX_CMD := "nix"
NIX_STORE_CMD := "nix-store"
NIXOS_REBUILD := "nixos-rebuild"
DARWIN_FIRST_BUILD := "./result/sw/bin/darwin-rebuild"
DARWIN_REBUILD := "darwin-rebuild"
RUNS_ENV := env("RUNS_ENV", "deployment")
SYSTEM := if os() == "macos" { "aarch64-darwin" } else { arch() + "-" + os() }
EXPECT_LOC := home_directory() + "/dotfiles"
MISE_BIN := home_directory() + "/.local/bin/mise"
MISE_CONFIG_DIR := env("MISE_CONFIG_DIR", env("XDG_CONFIG_HOME", home_directory() + "/.config") + "/mise")
MISE_GLOBAL_CONFIG_FILE := env("MISE_GLOBAL_CONFIG_FILE", MISE_CONFIG_DIR + "/config.toml")

# Verify Nix availability and display the build environment.
[default]
test: _check
    {{ NIX_CMD }} --version
    echo "Detected system: {{ SYSTEM }}"
    echo "Build environment: {{ RUNS_ENV }}"

[private]
_check:
    @if [ "{{ RUNS_ENV }}" = deployment ] && [ "{{ justfile_directory() }}" != "$(realpath "{{ EXPECT_LOC }}")" ]; then echo "Unexpected location - {{ justfile_directory() }}. Must locate at ~/dotfiles." >&2; exit 1; fi

[private]
_linux: _check
    @test "{{ SYSTEM }}" = x86_64-linux || { echo "Incompatible system: {{ SYSTEM }}" >&2; exit 1; }

[private]
_darwin: _check
    @test "{{ SYSTEM }}" = aarch64-darwin || { echo "Incompatible system: {{ SYSTEM }}" >&2; exit 1; }

[private]
_ci: _check
    @test "{{ RUNS_ENV }}" = ci || { echo "ci recipes require RUNS_ENV=ci" >&2; exit 1; }

nix-install: _check
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

nixos-build profile: _linux
    {{ NIX_CMD }} build ".#nixosConfigurations.{{ profile }}.config.system.build.toplevel" --verbose --show-trace --no-link --extra-experimental-features nix-command --extra-experimental-features flakes

nixos profile: _linux
    sudo {{ NIXOS_REBUILD }} switch --flake ".#{{ profile }}"

nix-darwin-init profile: _darwin
    {{ NIX_CMD }} build ".#darwinConfigurations.{{ profile }}.system" --verbose --show-trace
    sudo {{ DARWIN_FIRST_BUILD }} switch --flake ".#{{ profile }}"

nix-darwin-build profile: _darwin
    {{ NIX_CMD }} build ".#darwinConfigurations.{{ profile }}.system" --verbose --show-trace --no-link

nix-darwin profile: _darwin
    sudo {{ DARWIN_REBUILD }} switch --flake ".#{{ profile }}"

nix-home-build profile: _check
    {{ NIX_CMD }} run "nixpkgs#home-manager" -- build --no-out-link --debug --show-trace --flake ".#{{ profile }}"

nix-home profile: _check
    {{ NIX_CMD }} run "nixpkgs#home-manager" -- -b hm-bkp switch --flake ".#{{ profile }}"

nixos-eval profile: _check
    {{ NIX_CMD }} eval ".#nixosConfigurations.{{ profile }}.config.system.build.toplevel" --verbose --show-trace --extra-experimental-features nix-command --extra-experimental-features flakes

nix-darwin-eval profile: _check
    {{ NIX_CMD }} eval ".#darwinConfigurations.{{ profile }}.system" --verbose --show-trace --extra-experimental-features nix-command --extra-experimental-features flakes

nix-home-eval profile: _check
    {{ NIX_CMD }} eval ".#homeConfigurations.{{ profile }}.activationPackage.drvPath" --verbose --show-trace --extra-experimental-features nix-command --extra-experimental-features flakes

update: _check
    {{ NIX_CMD }} flake update

fmt: _check
    {{ NIX_CMD }} fmt

clean-store: _check
    {{ NIX_STORE_CMD }} --gc

clean-oldgen: _check
    nix-collect-garbage -d

legacy-install: _check sheldon-install mise-install sheldon-link legacy-shell tmux-install zellij-install scripts-link git-setup

sheldon-install: _check
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin

mise-install: _check mise-link
    if [ ! -x "{{ MISE_BIN }}" ]; then \
        bash -o pipefail -c 'curl --proto "=https" --tlsv1.2 -fsSL https://mise.run | MISE_INSTALL_PATH="{{ MISE_BIN }}" sh'; \
    fi
    MISE_CONFIG_FILE="{{ MISE_GLOBAL_CONFIG_FILE }}" "{{ MISE_BIN }}" trust "{{ justfile_directory() }}/mise/config.toml"
    MISE_CONFIG_FILE="{{ MISE_GLOBAL_CONFIG_FILE }}" "{{ MISE_BIN }}" install --yes

sheldon-link: _check
    ln -sf {{ justfile_directory() }}/sheldon {{ home_directory() }}/.config/

mise-link: _check
    mkdir -p "$(dirname "{{ MISE_GLOBAL_CONFIG_FILE }}")"
    if [ -e "{{ MISE_GLOBAL_CONFIG_FILE }}" ] || [ -L "{{ MISE_GLOBAL_CONFIG_FILE }}" ]; then \
        [ "{{ MISE_GLOBAL_CONFIG_FILE }}" -ef "{{ justfile_directory() }}/mise/config.toml" ] || \
        { echo "Refusing to overwrite {{ MISE_GLOBAL_CONFIG_FILE }}; back it up first." >&2; exit 1; }; \
    else \
        ln -s "{{ justfile_directory() }}/mise/config.toml" "{{ MISE_GLOBAL_CONFIG_FILE }}"; \
    fi

legacy-shell: _check
    mkdir -p {{ home_directory() }}/.zsh/.zsh_functions
    echo 'source $HOME/.zsh/.zshenv' > {{ home_directory() }}/.zshenv
    ln -sf {{ justfile_directory() }}/config/zsh/.zshenv {{ home_directory() }}/.zsh/.zshenv
    ln -sf {{ justfile_directory() }}/config/zsh/.zprofile {{ home_directory() }}/.zsh/.zprofile
    ln -sf {{ justfile_directory() }}/config/zsh/.zshrc {{ home_directory() }}/.zsh/.zshrc
    ln -sf {{ justfile_directory() }}/config/spaceship {{ home_directory() }}/.config/spaceship

tmux-install: _check
    ln -sf {{ justfile_directory() }}/config/tmux {{ home_directory() }}/.config/
    git clone https://github.com/tmux-plugins/tpm {{ home_directory() }}/.config/tmux/plugins/tpm

zellij-install: _check
    mkdir -p {{ home_directory() }}/config/zellij/config.kdl
    ln -sf {{ justfile_directory() }}/config/zellij/config.kdl {{ home_directory() }}/.config/zellij/

scripts-link: _check
    ln -sf {{ justfile_directory() }}/config/scripts {{ home_directory() }}/.scripts

nvim-install: _check nvim-build
    ln -sf {{ justfile_directory() }}/config/nvim {{ home_directory() }}/.config

nvim-build: _check
    ./config/scripts/build_neovim

git-setup: _check
    mkdir -p {{ home_directory() }}/.config/git
    cp {{ justfile_directory() }}/config/git/config {{ home_directory() }}/.config/git/config
    cp {{ justfile_directory() }}/config/git/allowed_signers {{ home_directory() }}/.config/git/allowed_signers

# Build the default CI profile, or a supplied profile.
ci-build profile=(if os() == "macos" { "suisui" } else { "nacho" }): _ci
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{ SYSTEM }}" in
        x86_64-linux) output="nixosConfigurations.{{ profile }}.config.system.build.toplevel" ;;
        aarch64-darwin) output="darwinConfigurations.{{ profile }}.system" ;;
        *) echo "Incompatible system: {{ SYSTEM }}" >&2; exit 1 ;;
    esac
    {{ NIX_CMD }} build --no-link --show-trace --system "{{ SYSTEM }}" --accept-flake-config ".#$output"

ci-home profile: _ci _linux
    {{ NIX_CMD }} run "nixpkgs#home-manager" -- build --no-out-link --show-trace --flake ".#{{ profile }}"
