# Repository Guidelines

## Project Structure & Module Organization

This repository manages cross-platform dotfiles with Nix Flakes. `flake.nix` is the main entry point. Machine-specific system settings live in `profiles/<name>/`, while user settings live in `home-manager/profiles/<name>/`. Reusable modules are grouped under `nixos/settings/`, `nix-darwin/settings/`, and `home-manager/` by platform and concern. Raw application configuration is stored in `config/`; legacy package and shell manifests are in `aqua/` and `sheldon/`. Keep host-specific choices in profiles and move shared behavior into reusable modules.

## Build, Test, and Development Commands

Run commands from the repository root (`~/dotfiles` for deployment targets).

- `make fmt`: format Nix and selected Lua files through treefmt.
- `nix flake check`: run flake checks, including formatting validation.
- `make nixos-eval-<profile>`: evaluate a NixOS configuration without building it.
- `make nixos-build-<profile>`: build NixOS without switching the host.
- `make nix-darwin-build-<profile>`: build a macOS configuration.
- `make nix-home-build-<profile>`: build a standalone Home Manager profile.
- `make test`: verify Nix availability and display the detected build environment.

Use deployment targets such as `make nixos-<profile>` only when an actual system switch is intended; they may require `sudo`.

## Coding Style & Naming Conventions

Format all changes with `make fmt`. Nix files use `nixfmt`; Lua files under `config/nvim/` and `config/wezterm/` use StyLua with four-space indentation and a 120-column limit. Name modules and directories with lowercase descriptive terms, such as `settings/system/networking.nix`. Follow existing module patterns: explicit imports, small concern-focused files, and profile names matching flake output names.

## Testing Guidelines

There is no separate unit-test framework. Validate the narrowest affected output first with an `*-eval-*` target, then run the corresponding `*-build-*` target for configuration changes. Run `nix flake check` before submitting. Changes to platform-specific modules should be checked against at least one relevant profile.

## Commit & Pull Request Guidelines

Recent commits use short imperative subjects, commonly scoped, for example `darwin: add drawio cask`, `nix: update flake.lock`, or `home(*): add ...`. Keep each commit focused. Pull requests should explain the affected platform/profile, list validation commands, and call out deployment or secret-handling implications. Include screenshots only for visible desktop or application changes.

## Security & Configuration Tips

Secrets are managed with sops-nix and `.sops.yaml`. Never commit decrypted values, private keys, generated `result` links, or host-local credentials. Edit encrypted files through the established SOPS workflow.
