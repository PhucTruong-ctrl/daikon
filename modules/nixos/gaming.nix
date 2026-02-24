{ pkgs, lib, config, prismlauncher-cracked, ... }:
let
  # Use cracked PrismLauncher (offline play) with extra Java AWT/X11 libs
  prismLauncher = prismlauncher-cracked.packages.${pkgs.system}.prismlauncher.override {
    additionalLibs = with pkgs; [
      libGL
      libX11
      libXext
      libXcursor
      libXrandr
      libXinerama
      libXi
      libXtst
      libXrender
      freetype
      zlib
      openal
      libpulseaudio
      alsa-lib
    ];
    jdks = [ pkgs.jdk17 ];
  };

  prismLauncherDesktop = pkgs.makeDesktopItem {
    name = "org.prismlauncher.PrismLauncher";
    desktopName = "Prism Launcher";
    comment = "Minecraft launcher";
    exec = "${prismLauncher}/bin/prismlauncher %U";
    icon = "${prismLauncher}/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg";
    terminal = false;
    categories = [ "Game" ];
    mimeTypes = [
      "application/x-modrinth-modpack+zip"
      "x-scheme-handler/prismlauncher"
    ];
    startupNotify = true;
    startupWMClass = "PrismLauncher";
  };
in {
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
      p7zip
    ];
  };

  # Work around decky-loader wrapper dropping system PATH entries.
  # Use the python entrypoint directly so `systemctl` from service PATH is visible.
  systemd.services.decky-loader.serviceConfig.ExecStart = lib.mkForce
    "${config.jovian.decky-loader.package}/bin/.decky-loader-wrapped";

  # Gamescope compositor for FSR upscaling and Vulkan presentation
  programs.gamescope = {
    enable = true;
    capSysNice = true;  # Allow priority scheduling
  };

  environment.systemPackages = with pkgs; [
    lutris
    heroic
    jdk17
    prismLauncher
    (lib.hiPrio prismLauncherDesktop)
    mangohud
    p7zip
  ];
}
