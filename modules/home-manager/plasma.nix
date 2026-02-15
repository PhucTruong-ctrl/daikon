{ lib, ... }: {
  #############################################################################
  # Plasma/KDE Configuration - Basic setup without theming
  #############################################################################
  programs.plasma = {
    enable = true;

    #=========================================================================
    # Workspace Settings - Keep default, no rice
    #=========================================================================
    workspace = {
      # Using default Breeze theme
      wallpaper = null; # Set manually
    };

    #=========================================================================
    # KWin Settings - Basic window management
    #=========================================================================
    kwin = {
      virtualDesktops = {
        number = 5;
        rows = 1;
        names = [ "Desktop 1" "Desktop 2" "Desktop 3" "Desktop 4" "Desktop 5" ];
      };
      borderlessMaximizedWindows = false;
      titlebarButtons = {
        left = [ "on-all-desktops" ];
        right = [ "minimize" "maximize" "close" ];
      };
    };

    #=========================================================================
    # Keyboard Shortcuts - Basic shortcuts
    #=========================================================================
    shortcuts = {
      # KWin shortcuts
      kwin = {
        # Desktop switching
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";

        # Window management
        "Window Close" = [ "Meta+C" "Alt+F4" ];
        "Window Maximize" = "Meta+F";
        "Window Minimize" = "Meta+PgDown";

        # Quick tile
        "Window Quick Tile Left" = "Meta+Left";
        "Window Quick Tile Right" = "Meta+Right";

        # Window switching
        "Walk Through Windows" = [ "Meta+Tab" "Alt+Tab" ];
        "Walk Through Windows (Reverse)" = [ "Meta+Shift+Tab" "Alt+Shift+Tab" ];
      };

      # Session management
      ksmserver = {
        "Lock Session" = [ "Meta+L" "Screensaver" ];
        "Log Out" = "Ctrl+Alt+Del";
      };

      # Plasmashell
      plasmashell = {
        "activate application launcher" = [ "Meta" "Alt+F1" ];
        "manage activities" = "Meta+Q";
      };
    };

    #=========================================================================
    # Custom Hotkeys (App Launchers)
    #=========================================================================
    hotkeys.commands = {
      "launch-terminal" = {
        name = "Launch Terminal";
        key = "Meta+T";
        command = "ghostty";
      };
      "launch-dolphin" = {
        name = "Launch Dolphin";
        key = "Meta+E";
        command = "dolphin";
      };
    };
  };

  #############################################################################
  # Konsole Settings (outside programs.plasma)
  #############################################################################
  programs.konsole = {
    enable = true;
    defaultProfile = "zsh";
    profiles.zsh = {
      name = "zsh";
      command = "zsh";
      font = {
        name = "JetBrains Mono";
        size = 11;
      };
      colorScheme = "Breeze";
    };
  };
}
