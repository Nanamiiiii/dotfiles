# dotfiles
Myuu's dotfiles using Nix Flakes.

## NixOS
Defined as follows in `.#nixosConfigurations`:
```nix
# NixOS
hoge = nixosSystem (nixosSystemArgs {
  profile = "hoge";
  username = "user";
  system = "x86_64-linux";
  desktop = true;
});

# WSL
fuga = nixosSystem (nixWslArgs {
  profile = "fuga";
  username = "user";
  system = "x86_64-linux";
  desktop = true;
});
```
- `profile` is used for retriving per-profile definitions from `profiles/` and `home-manager/profiles/`.
- For WSL, `nixWslArgs` is passed to `nixosSystem`.
- `desktop` indicates whether the target profile is deployed to the desktop or headless system.
    - Some GUI applications are not installed when `desktop = false`.

### Eval
```
make nixos-eval-<profile>
```

### Build
```
make nixos-build-<profile>
```

### Deploy
```
make nixos-<profile>
```

## macOS
Defined as follows in `.#darwinConfigurations`:
```nix
hoge = darwinSystem (darwinSystemArgs {
  profile = "hoge";
  username = "myuu";
  system = "aarch64-darwin";
});
```
- `profile` is used for retriving per-profile definitions from `profiles/` and `home-manager/profiles/`.

### Eval
```
make nix-darwin-eval-<profile>
```

### Build
```
make nix-darwin-build-<profile>
```

### Deploy
```
make nix-darwin-<profile>
```

## Only Home Manager
Defined as follows in `.#homeConfigurations`:
```nix
hoge = homeManagerConfiguration (homeManagerArgs {
  profile = "hoge";
  hostname = "hoge";
  username = "user";
  system = "x86_64-linux";
  desktop = false;
  wslhost = false;
});
```
- `profile` is used for retriving per-profile definitions from `home-manager/profiles/`.
- `hostname` and `username` must be set to the target hostname and username.
- `desktop` indicates whether the target profile is deployed to the desktop or headless system.
- `wslhost` indicates whether the target profile is deployed to the wsl or non-wsl system.

### Eval
```
make nix-home-eval-<profile>
```

### Build
```
make nix-home-build-<profile>
```

### Deploy
```
make nix-home-<profile>
```

## without Nix
For the non-nix host, `mise` and `sheldon` are used to deploy cli apps and shell plugins. CLI versions are defined in `mise/config.toml`. Configuration files are deployed by linking to actual files under `config/`.

### Linux
```
make legacy-install

# Install mise, link its global config, and install CLI tools only
make mise-install

# neovim can be installed / updated as follows
# This will install neovim into ~/.local/bin and create links to the configuration.
make nvim-install
```

### Windows

Download and run only `init.ps1` from **Windows PowerShell** (PowerShell 7 and Git do not need to be installed beforehand):

```powershell
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Nanamiiiii/dotfiles/main/scripts/init.ps1' -OutFile "$env:TEMP\dotfiles-init.ps1"
# Review the downloaded script before running it.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:TEMP\dotfiles-init.ps1"
```

- Requires **App Installer / WinGet 1.11 or later**, internet access, and administrator approval for the same Windows account. Install or update App Installer first if necessary. If WinGet reports that extended features are disabled, run `winget configure --enable` and retry.
- The script installs Git if missing, clones this repository over HTTPS into `~/dotfiles`, applies `scripts/configuration.winget` (including PowerShell 7, mise, GnuPG, WezTerm, Zed, and Starship), installs mise tools, and deploys the shell/application configuration. No SSH keys or preexisting PowerShell profile are required. Configuration agreements are accepted automatically; review the repository configuration as well as the script before running it.
- An existing `~/dotfiles` is reused without updating it. The script refreshes `PATH` after package installation and stops on installation or clone failures.
- mise uses a configuration symlink (normally `~/.config/mise/config.toml`). A matching link is reused; an unrelated existing file is not overwritten. Unset `MISE_GLOBAL_CONFIG_FILE` and `MISE_CONFIG_FILE` before setup; `MISE_CONFIG_DIR` and `XDG_CONFIG_HOME` affect the link location.
- After setup, open a new PowerShell 7 session. Windows OpenSSH Client remains an OS prerequisite for the deployed Git SSH configuration; enable that optional feature if unavailable.

