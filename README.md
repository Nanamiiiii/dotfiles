# dotfiles
dotfiles with Nix

## Install Nix
```bash
make nix-install
```

## NixOS
### Build & Switch 
```
make nixos-${HOST}
```

### Build Only
```
make nixos-build-${HOST}
```

## Darwin
### First Build
```bash
make nix-darwin-init-${HOST}
```

### Build & Switch
```bash
make nix-darwin-${HOST}
```

## Format
```bash
make fmt
```

## GC
```
make clean-store
```

