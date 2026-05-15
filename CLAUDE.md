# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Build & Deploy

All deployment commands must be run from `~/dotfiles` (enforced by the Makefile).

**NixOS (Linux x86_64):**
```sh
make nixos-eval-<profile>   # evaluate without building
make nixos-build-<profile>  # build without switching
make nixos-<profile>        # build and switch (requires sudo)
```

**nix-darwin (macOS aarch64):**
```sh
make nix-darwin-eval-<profile>
make nix-darwin-build-<profile>
make nix-darwin-<profile>   # requires sudo
# First-time only:
make nix-darwin-init-<profile>
```

**Standalone home-manager (headless hosts):**
```sh
make nix-home-eval-<profile>
make nix-home-build-<profile>
make nix-home-<profile>
```

### Format & Update
```sh
make fmt          # nix fmt (nixfmt for .nix, stylua for Lua)
make update       # nix flake update
make clean-store  # nix-store --gc
make clean-oldgen # nix-collect-garbage -d
```

### Legacy (non-Nix hosts)
```sh
make legacy-install   # sets up sheldon + aqua + symlinks
make nvim-install     # build neovim and link config
```

## Architecture

### Flake outputs

`flake.nix` defines three types of system configurations, each built by a different entry point:

| Output | Builder | Entry point | Used for |
|--------|---------|-------------|----------|
| `nixosConfigurations` | `nixos/default.nix` | `profiles/<profile>` | NixOS desktops & WSL |
| `darwinConfigurations` | `nix-darwin/default.nix` | `profiles/<profile>` | macOS (suisui) |
| `homeConfigurations` | `home-manager/standalone.nix` | `home-manager/profiles/<profile>` | headless Linux hosts without NixOS |

The `desktop` boolean passed to each system controls whether GUI applications are included.

### Profiles

Each machine has a named profile directory under `profiles/<name>/` (NixOS system-level config) and `home-manager/profiles/<name>/` (user-level config). A profile imports shared modules and composes them for that specific machine.

Current machines:
- `mafu` — NixOS workstation (x86_64)
- `yuki` — NixOS laptop, ThinkPad X13 Gen5 (x86_64)
- `nacho` — NixOS lab workstation (x86_64)
- `rika` / `saki` — NixOS-WSL instances on mafu/yuki
- `suisui` — nix-darwin MacBook Pro 2021 (aarch64)
- `xanadu` / `unyonyo` — standalone home-manager for lab servers

### Module layout

**`nixos/settings/`** — reusable NixOS system modules, grouped by concern:
- `boot/`, `graphics/`, `display/`, `desktop/`, `system/`, `nix/`, `misc/`

**`home-manager/`** — reusable home-manager modules:
- `common/` — shared across all platforms (cli, shell, editor, lang, nix, terminal, agents)
- `linux/` — Linux-only apps and fcitx5/kdeconnect/avatar
- `darwin/` — macOS-specific apps
- `desktop/` — window managers: niri (primary), hyprland (legacy), aerospace (macOS)
- `wsl/` — WSL-specific settings
- `services/` — background service configs (nextcloud, etc.)
- `security/` — yubikey, gpg
- `sops/` — secret decryption setup

### Secrets

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) using age keys. Encryption rules are in `.sops.yaml`. Secret files live in `secrets/` (system-level) and `home-manager/secrets/` (user-level).

### Overlays

`overlays/default.nix` applies two overlays globally:
- `inputs.nur.overlays.default` — Nix User Repository (own NUR: `github:Nanamiiiii/nur`)
- `inputs.llm-agents.overlays.default` — LLM agent packages

### Formatters

`treefmt.nix` configures two formatters triggered by `make fmt`:
- `nixfmt` for all `.nix` files
- `stylua` (spaces, indent 4, column 120) for `config/nvim/**/*.lua` and `config/wezterm/*.lua`

### Non-Nix config

`config/` contains raw dotfiles for tools managed outside Nix (nvim, zsh, tmux, wezterm, etc.). On legacy hosts these are symlinked by `make legacy-install`. On Nix hosts they are typically managed via home-manager's file linking.

`sheldon/` and `aqua/` hold plugin and CLI tool manifests for the legacy (non-Nix) shell setup.
