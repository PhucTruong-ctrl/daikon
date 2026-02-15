{ pkgs, ... }: {
  # User-specific packages (not system-wide)
  home.packages = with pkgs; [
    # Clipboard helpers (tmux copy-mode -> system clipboard)
    wl-clipboard

    # Browsers
    google-chrome

    # Media
    vlc

    # Communication
    discord
    betterdiscordctl

    # Office
    libreoffice-qt6-fresh

    # Database tools
    mongodb-compass
  ];
}
