{ pkgs, ... }: {
  # ──────────────────────────────────────────────────────────
  # Power management tuned for lower thermals on i5-1035G1
  # ──────────────────────────────────────────────────────────

  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      # CPU governor — powersave with intel_pstate lets HWP handle clocks
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy/performance policy — prioritise thermals
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Cap turbo boost percentage (100 = base clock only with powersave)
      CPU_MAX_PERF_ON_AC = 70;
      CPU_MAX_PERF_ON_BAT = 50;
      CPU_MIN_PERF_ON_AC = 5;
      CPU_MIN_PERF_ON_BAT = 5;

      # Keep turbo boost ON for snappy responsiveness
      # thermald + max_perf cap handle thermal limits instead
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # HWP dynamic boost — let Intel manage turbo intelligently on AC
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # WiFi power saving
      WIFI_PWR_ON_AC = "on";
      WIFI_PWR_ON_BAT = "on";

      # PCIe ASPM — max power savings
      PCIE_ASPM_ON_AC = "powersupersave";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # USB autosuspend
      USB_AUTOSUSPEND = 1;

      # SATA link power management
      SATA_LINKPWR_ON_AC = "med_power_with_dipm";
      SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
    };
  };

  # ── Kernel parameters for thermal optimisation ──
  boot.kernelParams = [
    # Disable NMI watchdog — saves ~1W, reduces thermal overhead
    "nmi_watchdog=0"
    # Intel pstate passive mode — lets the kernel scheduler control clocks
    # (better thermal response than HWP autonomous mode)
    "intel_pstate=passive"
    # Disable mitigations on a personal laptop for better perf (optional)
    # "mitigations=off"
  ];

  # ── Kernel sysctl tuning ──
  boot.kernel.sysctl = {
    # Lower swappiness — 20GB RAM doesn't need aggressive swapping
    "vm.swappiness" = 10;
    # Reduce dirty page writeback thresholds (less I/O spikes)
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    # Disable NMI watchdog via sysctl too (belt and suspenders)
    "kernel.nmi_watchdog" = 0;
    # Less aggressive compaction — reduces CPU overhead
    "vm.compaction_proactiveness" = 0;
  };

  # ── CPU undervolt profile for Intel i5-1035G1 ──
  boot.kernelModules = [ "msr" ];
  environment.systemPackages = [ pkgs.intel-undervolt ];

  environment.etc."intel-undervolt.conf".text = ''
    undervolt 0 'CPU' -50
    undervolt 1 'GPU' -50
    undervolt 2 'CPU Cache' -50
    undervolt 3 'System Agent' 0
    undervolt 4 'Analog I/O' 0
    undervolt 5 'Digital I/O' 0
    interval 5000
  '';

  systemd.services.intel-undervolt = {
    description = "Apply Intel undervolt profile";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "-${pkgs.kmod}/bin/modprobe msr";
      ExecStart = "-${pkgs.intel-undervolt}/bin/intel-undervolt apply";
    };
  };

  # ── Disable Baloo file indexer (KDE) — major CPU/IO hog ──
  environment.etc."xdg/baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';
}
