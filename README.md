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
just nixos-eval <profile>
```

### Build
```
just nixos-build <profile>
```

### Deploy
```
just nixos <profile>
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
just nix-darwin-eval <profile>
```

### Build
```
just nix-darwin-build <profile>
```

### Deploy
```
just nix-darwin <profile>
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
just nix-home-eval <profile>
```

### Build
```
just nix-home-build <profile>
```

### Deploy
```
just nix-home <profile>
```

## without Nix
For the non-nix host, `mise` and `sheldon` are used to deploy cli apps and shell plugins. CLI versions are defined in `mise/config.toml`. Configuration files are deployed by linking to actual files under `config/`.

### Linux
```
just legacy-install

# Install mise, link its global config, and install CLI tools only
just mise-install

# neovim can be installed / updated as follows
# This will install neovim into ~/.local/bin and create links to the configuration.
just nvim-install
```

### Windows

Download and run only `init.ps1` from **PowerShell** (PowerShell 7 and Git do not need to be installed beforehand):

```powershell
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Nanamiiiii/dotfiles/main/scripts/init.ps1' -OutFile "$env:TEMP\init.ps1"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:TEMP\init.ps1"
```

