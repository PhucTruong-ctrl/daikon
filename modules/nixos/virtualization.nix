{ pkgs, ... }: {
  # Enable Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Enable Waydroid for Android apps
  virtualisation.waydroid.enable = true;
}
