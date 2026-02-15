# NixOS Dotfiles

Personal NixOS configuration with Home Manager and Plasma Manager for a fully declarative desktop setup.

## Quick Start

### Initial Setup

1. Copy your hardware configuration:
```bash
sudo cp /etc/nixos/hardware-configuration.nix hosts/phuctruong-nixos/
```

2. Update hardware-configuration.nix with your actual disk UUIDs:
```bash
sudo blkid
```

3. Build and apply the configuration:
```bash
sudo nixos-rebuild switch --flake .#phuctruong-nixos
```

### Quick Commands

```bash
# Apply configuration
sudo nixos-rebuild switch --flake .#phuctruong-nixos

# Test build
sudo nixos-rebuild dry-build --flake .#phuctruong-nixos

# Update inputs
nix flake update

# Development shell
nix develop

# Python dev shells
nix develop .#py312
nix develop .#py313
nix develop .#py314
nix develop .#py315
```

## Repository Structure

```
nixos-dotfiles/
├── flake.nix                     # Main flake - entry point
├── flake.lock                    # Locked dependencies
├── hosts/
│   └── phuctruong-nixos/
│       ├── configuration.nix     # Host-specific config
│       └── hardware-configuration.nix  # Hardware scan
├── home/
│   └── phuctruong.nix           # User entry point
├── modules/
│   ├── nixos/                   # System modules
│   │   ├── default.nix          # Aggregator
│   │   ├── desktop.nix          # KDE Plasma + SDDM
│   │   ├── audio.nix            # PipeWire
│   │   ├── nvidia.nix           # NVIDIA Optimus/Prime
│   │   ├── networking.nix       # NetworkManager
│   │   ├── fcitx5.nix           # Vietnamese input
│   │   ├── shell.nix            # Zsh + oh-my-zsh
│   │   ├── virtualization.nix   # Docker + Waydroid
│   │   ├── gaming.nix           # Steam + Lutris
│   │   ├── packages.nix         # System packages
│   │   ├── fonts.nix            # Fonts
│   │   └── power.nix            # Power management
│   └── home-manager/            # User modules
│       ├── default.nix          # Aggregator
│       ├── plasma.nix           # KDE workspace config (basic)
│       ├── packages.nix         # User apps
│       └── tmux.nix             # Tmux config
```

## Features

### System
- **NixOS unstable** with flakes
- **KDE Plasma 6** desktop environment (basic, no rice)
- **NVIDIA Optimus** (Intel + NVIDIA MX330)
- **Docker** (rootless)
- **Waydroid** for Android apps
- **Steam** and **Lutris** for gaming
- **Fcitx5 + Bamboo** for Vietnamese typing

### Desktop
- Basic KDE Plasma 6 configuration without heavy theming
- Konsole with JetBrains Mono font
- Standard Breeze theme

### Development
- Multiple Python versions (3.12, 3.13, 3.14, 3.15)
- Node.js, Bun, Zig
- Git, GitHub CLI
- UV for Python package management

### Apps
- **Editors:** VS Code (Insiders via flake), Zed, Ghostty
- **Browsers:** Firefox, Microsoft Edge, Google Chrome
- **Communication:** Discord, Teams for Linux, Thunderbird, Caprine (with X11 for Vietnamese input)
- **Media:** VLC, YT Music Desktop
- **Office:** LibreOffice

## Flake Inputs

- **nixpkgs:** `nixos-unstable`
- **home-manager:** Master branch (follows unstable)
- **plasma-manager:** KDE configuration management
- **opencode:** AI coding assistant
- **vscode-insiders:** VS Code Insiders with FHS wrapper for extensions

## Key Bindings

| Shortcut | Action |
|----------|--------|
| `Meta+1/2/3` | Switch to Desktop 1/2/3 |
| `Meta+T` | Launch Ghostty Terminal |
| `Meta+E` | Launch Dolphin |
| `Meta+C` | Close Window |
| `Meta+F` | Maximize Window |
| `Meta+Tab` | Switch Windows |
| `Meta+L` | Lock Screen |

## Customization

| Task | File |
|------|------|
| Add system packages | `modules/nixos/packages.nix` |
| Add user apps | `modules/home-manager/packages.nix` |
| Change KDE settings | `modules/home-manager/plasma.nix` |
| Add shell aliases | `modules/nixos/shell.nix` |
| Update Vietnamese input | `modules/nixos/fcitx5.nix` |

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Plasma Manager](https://github.com/nix-community/plasma-manager)
- [NixOS Modules Wiki](https://nixos.wiki/wiki/NixOS_modules)

## License

MIT
