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
For the non-nix host, `aqua` and `sheldon` are used to deploy cli apps and shell plugins. Configuration files are deployed by linking to actual files under `config/`.

### Linux
```
make legacy-install

# neovim can be installed / updated as follows
# This will install neovim into ~/.local/bin and create links to the configuration.
make nvim-install
```

### Windows
```
pwsh -f .\scripts\init.ps1
```
- Run `init.ps1` on PowerShell.
- The script will request administrator privilege to create symbolic links.
- This will install some application via `winget`.

