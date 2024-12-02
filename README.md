# dotfiles
dotfiles with Nix

## Install Nix
```bash
make nix-install
```

## NixOS
### Build & Switch 
```bash
make nixos-${HOST}
```

### Build Only
```bash
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

### Build Only
```bash
make nix-darwin-build-${HOST}
```

## Format
```bash
make fmt
```

## Update
```bash
make update
```

## GC
```bash
make clean-store
```

