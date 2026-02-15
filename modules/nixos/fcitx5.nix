{ pkgs, ... }: {
  # Input method environment variables
  # GTK_IM_MODULE + QT_IM_MODULE: Required for GTK/Qt apps to detect fcitx5
  # XMODIFIERS: for XWayland/X11 legacy apps
  # NIXOS_OZONE_WL: Electron apps use native Wayland
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "fcitx";

    # Electron on Plasma Wayland: X11 is still the most reliable for fcitx5.
    # This makes VS Code / Teams-for-Linux use XWayland while you stay on a
    # Wayland session.
    ELECTRON_OZONE_PLATFORM_HINT = "x11";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        # GTK support (GTK2 + GTK3 + GTK4)
        (fcitx5-gtk.override { withGTK2 = true; })
        # Input methods
        fcitx5-mozc
        fcitx5-bamboo
        # KDE/Qt integration
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-configtool
      ];
    };
  };
}
