{ config, pkgs, ... }: {
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
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Load nvidia module for early KMS
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.stable ];
}
