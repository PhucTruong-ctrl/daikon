<div align="center">

<img src="assets/desktop.png" alt="The daikon desktop: NixOS, KDE Plasma, Home Manager" width="900">

# daikon

**A dotfiles garden for a NixOS + KDE Plasma desktop :  every graft stowable, nothing precious.**

</div>

---

## Why this name?

> **daikon** *n.* :  a large white radish, mild, versatile, and foundational in East Asian cuisine.

Dotfiles are grafts. A keybind, a wallpaper, a shell rc file: each one is a scion tied onto the root system of your machine. `daikon` holds those grafts, and the scripts that plant them.

Three reasons, all pointing the same way:

**It is a root vegetable.** A daikon is a root vegetable: the part of the plant that survives the season and feeds the next one. It is the part you rarely see, and nothing grows without it.

**It is what Stow does.** GNU Stow grafts packages into a target directory. `$HOME` is the rootstock; every top-level directory here is a scion grafted onto it. Stow's manual uses the same metaphor.

**It outlives the setup.** The old name was `nixos-dotfiles`, which described one moment: the OS I happen to run and the desktop I happen to run it in. Swap NixOS for another distro, or KDE for another desktop, and that name becomes a lie. `daikon` names the practice, not the inventory. The packages can change; the daikon stays.

## What this is

Everything on this machine that a human edits, and nothing that a machine generates.

| In | Out |
| --- | --- |
| NixOS modules, Home Manager configs, Plasma settings | Build artifacts and cache |
| Shell rc, editor settings, terminal config | Build logs and derivation outputs |
| Service definitions, system tuning | Generated configuration files |
| User-authored plugin settings | Downloaded plugin payloads |
| | Browser profiles and credentials |

Every top-level directory is a **flake module** that mirrors the exact path the file occupies in the Nix store:

```
modules/nixos/packages.nix   ->   /etc/nixos/modules/nixos/packages.nix
home/phuctruong.nix          ->   /home/phuctruong/.config/home-manager/home.nix
```

## Quick Start

### Initial Setup

1. Copy your hardware configuration:
```bash
cp /etc/nixos/hardware-configuration.nix hosts/phuctruong-nixos/hardware-configuration.nix
```

2. Update `hardware-configuration.nix` with your actual disk UUIDs:
```bash
nixos-generate-config --show-hardware-config | tee hosts/your-host/hardware-configuration.nix
```

3. Build and apply the configuration:
```bash
sudo nixos-rebuild switch --flake .#phuctruong-nixos
```

### Quick Commands

```bash
# Build and test without applying
nixos-rebuild build --flake .#phuctruong-nixos

# Update flake inputs
nix flake update

# Garbage collect old generations
sudo nix-collect-garbage -d
```

### Tailscale (Manual Login Mode)

This setup enables the `tailscaled` service declaratively. Login is still manual by design.

```bash
sudo systemctl start tailscaled
sudo tailscale up
```

## Repository Structure

```
.
├── flake.nix                 # Flake entry point
├── flake.lock                # Pinned inputs
├── LICENSE                   # MIT License
├── README.md                 # This file
├── hosts/
│   └── phuctruong-nixos/
│       ├── configuration.nix  # Host-specific config
│       └── hardware-configuration.nix  # Generated hardware config
├── home/
│   └── phuctruong.nix        # Home Manager user config
├── modules/
│   ├── home-manager/
│   │   ├── default.nix       # Home Manager entry point
│   │   ├── fcitx5.nix        # Vietnamese input method
│   │   ├── packages.nix      # User packages
│   │   ├── plasma.nix        # KDE Plasma settings
│   │   ├── spicetify.nix     # Spotify theming
│   │   └── tmux.nix          # Tmux config
│   └── nixos/
│       ├── default.nix       # NixOS entry point
│       ├── audio.nix         # PipeWire/PulseAudio
│       ├── bluetooth.nix     # Bluetooth
│       ├── desktop.nix       # Desktop environment
│       ├── fcitx5.nix        # Input method (system)
│       ├── fonts.nix         # Fonts
│       ├── gaming.nix        # Steam, Proton, etc.
│       ├── networking.nix    # Network, firewall
│       ├── nvidia.nix        # NVIDIA Optimus
│       ├── packages.nix      # System packages
│       ├── power.nix         # TLP, CPU scaling
│       ├── shell.nix         # Shell (zsh, starship)
│       └── virtualization.nix # Libvirt, QEMU
```

## Features

### System
- NixOS unstable with flakes
- Home Manager for user configuration
- Plasma Manager for KDE Plasma settings

### Power & Thermal Management
- TLP with tuned settings for i5-1035G1 (max 70% perf on AC, 50% on battery)
- CPU governor: performance on AC, powersave on battery
- Intel undervolting via `intel-undervolt`
- NVIDIA clock cap service for GPU power management

### Desktop
- KDE Plasma 6 with minimal theming
- Fcitx5 Vietnamese input method
- Spicetify for Spotify theming

### Development
- Multiple Python versions (3.12, 3.13, 3.14, 3.15)
- VS Code, VS Code Insiders, Ghostty terminal
- Multiple Node.js versions via nix-shell

### Apps
- **Editors:** VS Code, VS Code Insiders, Ghostty (terminal)
- **Browsers:** Firefox, Google Chrome
- **Gaming:** Steam, Heroic Games Launcher, PrismLauncher
- **Media:** MPV, VLC, Spotify (with Spicetify)

### Peripherals
- **BIOI SAMICE** mechanical keyboard via VIA/QMK
- Logitech mouse with Solaar
- Wacom tablet support

## Flake Inputs

| Input | Source | Purpose |
| --- | --- | --- |
| nixpkgs | github:NixOS/nixpkgs/nixos-unstable | Base packages |
| home-manager | github:nix-community/home-manager/release-24.11 | User config |
| plasma-manager | github:hmgle/plasma-manager | KDE Plasma config |
| nixos-hardware | github:NixOS/nixos-hardware | Hardware quirks |

## Key Bindings

| Shortcut | Action |
| --- | --- |
| `Meta+Enter` | Launch Ghostty |
| `Meta+Space` | Application launcher |
| `Meta+Shift+Q` | Close window |
| `Meta+Shift+E` | Logout menu |
| `Meta+F` | Fullscreen |
| `Meta+Shift+F` | Toggle floating |
| `Meta+V` | Toggle floating/tiling |

## Customization

| Task | File |
| --- | --- |
| Add system package | `modules/nixos/packages.nix` |
| Add user package | `modules/home-manager/packages.nix` |
| Change keybindings | `modules/home-manager/shell.nix` |
| Adjust Plasma settings | `modules/home-manager/plasma.nix` |
| Tweak Fcitx5 | `modules/home-manager/fcitx5.nix` |

## Migrating to Arch

The Arch equivalent of this setup lives in **rootstock**:

https://github.com/PhucTruong-ctrl/rootstock

Per-module mapping was removed; see the reference there.

## Related Repositories

- **[rootstock](https://github.com/PhucTruong-ctrl/rootstock)** :  Dotfiles for CachyOS + niri + Noctalia
- **[beetroot](https://github.com/PhucTruong-ctrl/beetroot)** :  Dotfiles for CachyOS + Hyprland + Quickshell
- **[horseradish](https://github.com/PhucTruong-ctrl/horseradish)** :  Dotfiles for Omarchy + Hyprland + Neovim

## License

MIT :  see [LICENSE](LICENSE).