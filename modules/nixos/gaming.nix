{ pkgs, lib, config, ... }: {
  # Required 32-bit userspace libraries for Steam/Proton.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Gaming configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode.enable = true;

  jovian.decky-loader = {
    enable = true;
    user = "phuctruong";
    package = pkgs.decky-loader.overridePythonAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        substituteInPlace $out/lib/python*/site-packages/decky_loader/localplatform/localplatformlinux.py \
          --replace-fail 'env: ENV | None = {"LD_LIBRARY_PATH": ""}' 'env: ENV | None = None'
        substituteInPlace $out/lib/python*/site-packages/decky_loader/helpers.py \
          --replace-fail 'env={} if localplatform.ON_LINUX else None' 'env=None if localplatform.ON_LINUX else None'
      '';
    });
    extraPackages = with pkgs; [
      systemd
      python3
    ];
  };

  # Work around decky-loader wrapper dropping system PATH entries.
  # Use the python entrypoint directly so `systemctl` from service PATH is visible.
  systemd.services.decky-loader.serviceConfig.ExecStart = lib.mkForce
    "${config.jovian.decky-loader.package}/bin/.decky-loader-wrapped";

  environment.systemPackages = with pkgs; [
    lutris
    heroic
    jdk17
    (prismlauncher.override {
      additionalLibs = [
        libGL
        libX11
        libXext
        libXcursor
        libXrandr
        libXinerama
        libXi
        openal
        libpulseaudio
        alsa-lib
      ];
      jdks = [ jdk17 ];
    })
    mangohud
  ];
}
