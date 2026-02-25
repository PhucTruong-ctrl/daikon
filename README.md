# NixOS Dotfiles

Personal NixOS configuration with Home Manager and Plasma Manager for a fully declarative desktop setup.

## Hardware

| Component | Spec |
|-----------|------|
| **Laptop** | ASUS VivoBook |
| **CPU** | Intel Core i5-1035G1 @ 1.00 GHz (4C/8T, turbo 3.6 GHz) |
| **GPU (iGPU)** | Intel UHD G1 (Ice Lake) |
| **GPU (dGPU)** | NVIDIA GeForce MX330 (2 GB VRAM) |
| **RAM** | 20 GB DDR4 |
| **Storage** | 477 GB NVMe SSD (BTRFS) |
| **Swap** | 23.5 GB partition |
| **Keyboard** | BIOI SAMICE (QMK/VIA, vendor `0x8101`, product `0x5349`) |

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

### Tailscale (Manual Login Mode)

This setup enables the `tailscaled` service declaratively. Login is still manual by design.

```bash
# Rebuild and apply
sudo nixos-rebuild switch --flake .#phuctruong-nixos

# Check service
systemctl is-enabled tailscaled
systemctl is-active tailscaled

# First-time login
sudo tailscale up
tailscale status
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
│   │   ├── desktop.nix          # KDE Plasma + SDDM + udev
│   │   ├── audio.nix            # PipeWire
│   │   ├── bluetooth.nix        # Bluetooth + Blueman
│   │   ├── nvidia.nix           # NVIDIA Optimus/Prime
│   │   ├── networking.nix       # NetworkManager + Tailscale
│   │   ├── fcitx5.nix           # Vietnamese input (env vars)
│   │   ├── shell.nix            # Zsh + oh-my-zsh + direnv
│   │   ├── virtualization.nix   # Docker + Waydroid
│   │   ├── gaming.nix           # Steam + Lutris + Decky
│   │   ├── packages.nix         # System packages
│   │   ├── fonts.nix            # Fonts
│   │   └── power.nix            # TLP + undervolt + sysctl
│   └── home-manager/            # User modules
│       ├── default.nix          # Aggregator
│       ├── plasma.nix           # KDE workspace config (basic)
│       ├── packages.nix         # User apps
│       ├── tmux.nix             # Tmux config
│       ├── spicetify.nix        # Spotify theming/extensions
│       └── fcitx5.nix           # Vietnamese input (Bamboo VNI)
```

## Features

### System
- **NixOS unstable** with flakes
- **KDE Plasma 6** desktop environment (basic, no rice)
- **NVIDIA Optimus** (Intel iGPU + NVIDIA MX330 dGPU, Prime Offload)
- **Docker** (rootless, does not start at boot — socket-activated on first use)
- **Steam**, **Lutris**, **Heroic** for gaming
- **Fcitx5 + Bamboo** for Vietnamese typing (VNI method)
- **Decky Loader** with plugins for Steam Gamepad UI

### Power & Thermal Management
- **TLP** with tuned settings for i5-1035G1 (max 70% perf on AC, 50% on battery)
- **Intel undervolt** -50mV on CPU, GPU, CPU Cache
- **Turbo boost** ON when plugged in, OFF on battery
- **Kernel params:** `nmi_watchdog=0`, `intel_pstate=passive`
- **Sysctl tuning:** swappiness 10, reduced dirty ratios, disabled compaction
- **Baloo file indexer** disabled (KDE background CPU/IO hog)
- Achieved ~20°C thermal reduction (73°C → 50-54°C idle)

### Desktop
- Basic KDE Plasma 6 configuration without heavy theming
- Konsole with JetBrains Mono font
- Standard Breeze theme
- 5 virtual desktops

### Development
- Multiple Python versions (3.12, 3.13, 3.14, 3.15)
- Node.js, Bun, Zig
- Git, GitHub CLI
- UV for Python package management
- **OpenCode** AI coding assistant (from flake input)
- VS Code Insiders (FHS-wrapped for extension support)

### Apps
- **Editors:** VS Code, VS Code Insiders, Ghostty (terminal)
- **Browsers:** Firefox, Google Chrome
- **Communication:** Discord (with BetterDiscord), Caprine (with X11 for Vietnamese input)
- **Media:** VLC, Spotify (with Spicetify: adblockify, hidePodcasts, shuffle)
- **Office:** LibreOffice
- **Gaming:** Steam, Lutris, Heroic, PrismLauncher (cracked, offline), Honkers Railway Launcher (HSR), r2modman, Gale
- **Tools:** VIA (keyboard configurator), MangoHud, GOverlay, ProtonPlus, Remmina, LocalSend

### Peripherals
- **BIOI SAMICE** mechanical keyboard via VIA/QMK
  - Custom 4-layer keymap with Fn layer (vim-style HJKL arrows, media controls, RGB)
  - udev rules for non-root HID access in `desktop.nix`

## Flake Inputs

| Input | Source | Purpose |
|-------|--------|---------|
| **nixpkgs** | `nixos-unstable` | Base packages |
| **home-manager** | Master (follows unstable) | User-level config management |
| **plasma-manager** | nix-community | Declarative KDE Plasma settings |
| **opencode** | `anomalyco/opencode` (dev branch) | AI coding assistant |
| **vscode-insiders** | `auguwu/vscode-insiders-nix` | VS Code Insiders with auto-updated hashes |
| **spicetify-nix** | `Gerg-L/spicetify-nix` | Nix-native Spotify theming/extensions |
| **jovian** | Jovian-Experiments | Decky Loader for Steam Gamepad UI |
| **aagl** | `ezKEa/aagl-gtk-on-nix` | Honkers Railway Launcher (Honkai Star Rail) |
| **prismlauncher-cracked** | `Diegiwg/PrismLauncher-Cracked` | Offline Minecraft launcher |

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
| Change power/thermal settings | `modules/nixos/power.nix` |
| NVIDIA / GPU config | `modules/nixos/nvidia.nix` |
| Docker / virtualization | `modules/nixos/virtualization.nix` |
| Gaming (Steam, launchers) | `modules/nixos/gaming.nix` |

## Arch / CachyOS Equivalent Reference

This repo serves as a reference when migrating to Arch-based distros (CachyOS, EndeavourOS, etc.). Below maps every NixOS module to its Arch equivalent so an AI agent or human can reproduce this setup on a standard Linux system.

### Package Mapping

<details>
<summary><b>System packages</b> — <code>modules/nixos/packages.nix</code> + <code>flake.nix</code></summary>

```bash
# Core CLI
sudo pacman -S vim wget git github-cli jq fastfetch htop lshw lm_sensors usbutils btrfs-progs

# Development
sudo pacman -S nodejs bun zig ghostty python python-pip uv pyenv docker docker-compose

# Desktop / Peripherals
sudo pacman -S via remmina localsend

# Gaming
sudo pacman -S steam lutris heroic-games-launcher mangohud goverlay gamemode lib32-gamemode
paru -S protonplus prismlauncher  # AUR

# Media / Communication
sudo pacman -S vlc discord libreoffice-fresh
paru -S betterdiscordctl spotify spicetify-cli  # AUR

# Fonts
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-liberation \
  ttf-fira-code ttf-jetbrains-mono ttf-jetbrains-mono-nerd

# Vietnamese input
sudo pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool
paru -S fcitx5-bamboo  # AUR

# AppImage apps (just download and run on Arch, no wrapper needed)
# - Antigravity Tools: https://github.com/lbjlaq/Antigravity-Manager/releases
# - r2modman: https://github.com/ebkr/r2modmanPlus/releases
# - Gale: https://github.com/Kesomannen/gale/releases

# Honkai Star Rail
paru -S honkers-railway-launcher  # AUR
```

</details>

### Service & Config Mapping

| NixOS Module | What It Does | Arch Equivalent |
|--------------|-------------|-----------------|
| `desktop.nix` | KDE Plasma 6 + SDDM + udev rules | `sudo pacman -S plasma sddm` + `/etc/udev/rules.d/99-via-keyboard.rules` |
| `audio.nix` | PipeWire (replaces PulseAudio) | `sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber` |
| `bluetooth.nix` | Bluetooth + Blueman | `sudo pacman -S bluez bluez-utils blueman` + `systemctl enable bluetooth` |
| `networking.nix` | NetworkManager + Tailscale + autoheal timer | `sudo pacman -S networkmanager tailscale` + `systemctl enable NetworkManager tailscaled` |
| `shell.nix` | Zsh + oh-my-zsh + direnv | `sudo pacman -S zsh direnv` + `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| `nvidia.nix` | NVIDIA Optimus Prime Offload + clock cap | CachyOS auto-detects; or `sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils` |
| `power.nix` | TLP + undervolt + sysctl + kernel params | See [Power & Thermal Setup](#power--thermal-setup-arch) below |
| `virtualization.nix` | Docker rootless (no boot start) | `sudo pacman -S docker` + `systemctl enable docker.socket` (not `docker.service`) |
| `gaming.nix` | Steam + Decky Loader + Gamescope + PrismLauncher | `sudo pacman -S steam gamescope` + Decky via install script |
| `fcitx5.nix` | Fcitx5 env vars for Wayland/Electron | Add to `~/.pam_environment` or `~/.config/environment.d/` |
| `fonts.nix` | System fonts | `sudo pacman -S` (see packages above) |

### Power & Thermal Setup (Arch)

The `power.nix` module contains critical thermal tuning. On Arch/CachyOS:

```bash
# TLP
sudo pacman -S tlp
sudo systemctl enable --now tlp
sudo systemctl mask power-profiles-daemon  # Conflicts with TLP
```

Edit `/etc/tlp.conf`:
```ini
CPU_SCALING_GOVERNOR_ON_AC=powersave
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_AC=balance_power
CPU_ENERGY_PERF_POLICY_ON_BAT=power
CPU_MAX_PERF_ON_AC=70
CPU_MAX_PERF_ON_BAT=50
CPU_MIN_PERF_ON_AC=5
CPU_MIN_PERF_ON_BAT=5
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0
CPU_HWP_DYN_BOOST_ON_AC=1
CPU_HWP_DYN_BOOST_ON_BAT=0
WIFI_PWR_ON_AC=on
WIFI_PWR_ON_BAT=on
PCIE_ASPM_ON_AC=powersupersave
PCIE_ASPM_ON_BAT=powersupersave
USB_AUTOSUSPEND=1
SATA_LINKPWR_ON_AC=med_power_with_dipm
SATA_LINKPWR_ON_BAT=med_power_with_dipm
```

```bash
# Intel undervolt
paru -S intel-undervolt
sudo vim /etc/intel-undervolt.conf
# undervolt 0 'CPU' -50
# undervolt 1 'GPU' -50
# undervolt 2 'CPU Cache' -50
sudo systemctl enable --now intel-undervolt

# Kernel parameters (add to bootloader config)
# nmi_watchdog=0 intel_pstate=passive

# Sysctl tuning
sudo tee /etc/sysctl.d/99-performance.conf << 'EOF'
vm.swappiness = 10
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
kernel.nmi_watchdog = 0
vm.compaction_proactiveness = 0
EOF
sudo sysctl --system

# Disable Baloo (KDE file indexer)
balooctl6 disable
```

### NVIDIA Optimus Setup (Arch)

The `nvidia.nix` module configures Prime Offload with fine-grained power management. On CachyOS this is mostly automatic, but for reference:

```
# nvidia.nix key settings:
# - modesetting.enable = true
# - powerManagement.enable = true
# - powerManagement.finegrained = true (dGPU powers off when idle)
# - prime.offload.enable = true
# - intelBusId = "PCI:0:2:0"
# - nvidiaBusId = "PCI:2:0:0"
# - GPU clock cap: nvidia-smi --lock-gpu-clocks=0,1101
```

### Fcitx5 Vietnamese Input (Arch)

The `fcitx5.nix` + `home-manager/fcitx5.nix` modules set up Vietnamese typing. On Arch:

```bash
# Environment variables — add to ~/.config/environment.d/fcitx5.conf
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=fcitx
ELECTRON_OZONE_PLATFORM_HINT=x11   # Electron apps need X11 for fcitx5
```

Fcitx5 config is in `home-manager/fcitx5.nix`:
- Trigger key: `Control+Shift_L`
- Input method: **Bamboo (VNI)**
- `ShareInputState=All` (same input state across all windows)

### VIA Keyboard Setup (Arch)

```bash
# Install VIA
sudo pacman -S via

# udev rules for BIOI SAMICE (vendor 0x8101, product 0x5349)
sudo tee /etc/udev/rules.d/99-via-keyboard.rules << 'EOF'
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="input", TAG+="uaccess"
SUBSYSTEM=="usb", ATTR{idVendor}=="8101", ATTR{idProduct}=="5349", MODE="0660", GROUP="input", TAG+="uaccess"
EOF
sudo udevadm control --reload-rules && sudo udevadm trigger

# Add user to input group
sudo usermod -aG input $USER

# Keymap files are in the companion omarchy-dotfiles repo:
# https://github.com/PhucTruong-ctrl/omarchy-dotfiles/tree/master/keyboards/bioi_samice
```

### KDE Plasma Shortcuts (Arch)

The `home-manager/plasma.nix` module defines these shortcuts. On Arch, set them manually in KDE System Settings → Shortcuts, or import via `kwriteconfig6`:

| Shortcut | Action |
|----------|--------|
| `Meta+1` through `Meta+5` | Switch to Desktop 1–5 |
| `Meta+T` | Launch Ghostty |
| `Meta+E` | Launch Dolphin |
| `Meta+C` | Close Window |
| `Meta+F` | Maximize Window |
| `Meta+Tab` / `Alt+Tab` | Walk Through Windows |
| `Meta+L` | Lock Session |
| `Meta+Q` | Manage Activities |
| `Meta` | Application Launcher |
| `Ctrl+Alt+Del` | Log Out |

### Tmux Config (Arch)

The `home-manager/tmux.nix` settings. On Arch, put in `~/.config/tmux/tmux.conf`:

```bash
set -g mouse on
set -s escape-time 0
set -g set-clipboard on
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
bind-key -T copy-mode y send-keys -X copy-pipe-and-cancel "wl-copy"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"
bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"
```

### Shell Config (Arch)

From `shell.nix`. On Arch, add to `~/.zshrc`:

```bash
# oh-my-zsh plugins: git, sudo, docker, z
# Theme: robbyrussell

# Aliases
alias ll="ls -l"
alias la="ls -la"
```

### Spicetify (Arch)

From `home-manager/spicetify.nix`:

```bash
paru -S spicetify-cli
# Extensions: adblockify, hidePodcasts, shuffle
# Custom apps: marketplace
```

## Related Repositories

- **[omarchy-dotfiles](https://github.com/PhucTruong-ctrl/omarchy-dotfiles)** — Dotfiles for Omarchy/Arch/CachyOS (Hyprland, Neovim, Waybar, keyboard configs, game configs, etc.)

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Plasma Manager](https://github.com/nix-community/plasma-manager)
- [NixOS Modules Wiki](https://nixos.wiki/wiki/NixOS_modules)
- [NixOS AppImage Wiki](https://nixos.wiki/wiki/Appimage)
- [CachyOS Wiki](https://wiki.cachyos.org/)
- [Arch Wiki — TLP](https://wiki.archlinux.org/title/TLP)
- [Arch Wiki — NVIDIA Optimus](https://wiki.archlinux.org/title/NVIDIA_Optimus)
- [Arch Wiki — Fcitx5](https://wiki.archlinux.org/title/Fcitx5)

## License

MIT
