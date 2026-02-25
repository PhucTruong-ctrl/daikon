{ pkgs, lib, ... }: {
  # System-wide packages.
  # CachyOS equivalent: sudo pacman -S <package>

  environment.systemPackages = with pkgs; [
    # ── Core CLI tools ──
    vim
    wget
    git
    gh
    jq
    fastfetch
    htop
    lshw
    lm_sensors
    usbutils        # lsusb — was missing, needed for keyboard/USB debugging

    # ── Filesystem ──
    btrfs-progs
    kdePackages.partitionmanager

    # ── Development ──
    nodejs
    bun
    zig
    ghostty          # Terminal emulator

    # ── Hardware / Peripherals ──
    via              # QMK keyboard configurator (BIOI SAMICE)

    # ── Remote / Network ──
    remmina          # RDP/VNC/SSH remote desktop client
    localsend        # AirDrop alternative (LAN file sharing)

    # ── Gaming tools ──
    protonplus       # Proton-GE manager
    goverlay         # MangoHud/vkBasalt overlay config GUI

    # ── Python (multi-version) ──
    python312
    (lib.meta.lowPrio python313)
    (lib.meta.lowPrio python314)
    (lib.meta.lowPrio python315)
    uv               # Fast Python package manager
    pyenv            # Python version manager

    # ── System utilities ──
    mangohud         # FPS/GPU overlay for games
    noisetorch       # Microphone noise suppression
  ];
}
