{ ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Keep keyboard layout standard US; Vietnamese typing is handled by fcitx5.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # ── VIA keyboard configurator — udev rules for USB HID access ──
  # Without this, VIA can't communicate with the BIOI SAMICE keyboard
  # unless run as root. This grants the 'input' group raw HID access.
  services.udev.extraRules = ''
    # VIA/QMK compatible keyboards — allow user access to raw HID devices
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="input", TAG+="uaccess"
    # BIOI SAMICE keyboard specifically (vendorId 0x8101, productId 0x5349)
    SUBSYSTEM=="usb", ATTR{idVendor}=="8101", ATTR{idProduct}=="5349", MODE="0660", GROUP="input", TAG+="uaccess"
  '';
}
