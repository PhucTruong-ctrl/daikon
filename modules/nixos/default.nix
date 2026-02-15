{ ... }: {
  imports = [
    ./desktop.nix
    ./audio.nix
    ./bluetooth.nix
    ./nvidia.nix
    ./networking.nix
    ./fcitx5.nix
    ./shell.nix
    ./virtualization.nix
    ./gaming.nix
    ./packages.nix
    ./fonts.nix
    ./power.nix
  ];
}
