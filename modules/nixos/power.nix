{ ... }: {
  # Power management
  # Note: power-profiles-daemon is disabled because it conflicts with tlp
  services.power-profiles-daemon.enable = true;
  #services.tlp = {
  #  enable = true;
  #  settings = {
  #    CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  };
  #};
}
