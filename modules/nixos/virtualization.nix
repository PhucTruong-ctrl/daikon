{ pkgs, ... }: {
  # Enable Docker — rootless only, no system daemon burning CPU at idle
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # Don't start Docker daemon at boot — start on first use instead
    enableOnBoot = false;
  };

  # Waydroid disabled — runs a full Android container at boot for no reason
  # Re-enable when you actually need Android apps:
  #   virtualisation.waydroid.enable = true;
  virtualisation.waydroid.enable = false;
}
