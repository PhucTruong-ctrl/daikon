{ pkgs, ... }: {
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
  environment.systemPackages = with pkgs; [
    lutris
    heroic
    mangohud
  ];
}
