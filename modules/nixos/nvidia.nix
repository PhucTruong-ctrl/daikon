{ config, ... }: {
  # Enable NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for most setups
    modesetting.enable = true;

    # Power management (for Optimus laptops)
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Use open-source kernel module (nouveau) - set to false for proprietary driver
    open = false;

    # Enable the NVIDIA settings menu
    nvidiaSettings = true;

    # Use the stable driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Optimus Prime configuration
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Intel integrated GPU
      intelBusId = "PCI:0:2:0";
      # NVIDIA discrete GPU
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  # Load nvidia module for early KMS
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.stable ];

  # Some mobile GPUs require this flag before clock controls are exposed.
  boot.extraModprobeConfig = ''
    options nvidia NVreg_RegistryDwords="OverrideMaxPerf=0x1"
  '';

  # Attempt to cap NVIDIA boost clocks near 1100 MHz for lower thermals.
  # If the GPU/driver does not support lock clocks, this safely no-ops.
  systemd.services.nvidia-clock-cap = {
    description = "Cap NVIDIA boost clocks";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "-${config.hardware.nvidia.package.bin}/bin/nvidia-smi --lock-gpu-clocks=0,1101";
    };
  };
}
