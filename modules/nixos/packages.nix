{ pkgs, lib, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    # Core tools
    vim
    wget
    git
    gh
    nodejs
    jq
    fastfetch
    htop
    lshw
    lm_sensors

    # Btrfs tools
    btrfs-progs
    kdePackages.partitionmanager

    # Development
    bun
    zig
    ghostty
    via
    remmina

    # Python (multi-version)
    python312
    (lib.meta.lowPrio python313)
    (lib.meta.lowPrio python314)
    (lib.meta.lowPrio python315)
    uv
    pyenv

    # Window
    protonplus

    # System utilities (excluded: lenovo-legion)
    noisetorch
  ];
}
