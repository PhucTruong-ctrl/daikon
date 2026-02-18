{ pkgs, ... }: {
  # Power management tuned for lower thermals.
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MAX_PERF_ON_AC = 80;
      CPU_MAX_PERF_ON_BAT = 60;
    };
  };

  # CPU undervolt profile for Intel i5-1035G1.
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
}
