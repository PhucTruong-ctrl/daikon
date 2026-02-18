{
  description = "NixOS + Home Manager configuration with plasma-manager for KDE";

  inputs = {
    # Use unstable as the base for entire system (latest Plasma, etc.)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";  # master follows unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # opencode uses its own nixpkgs (unstable) to avoid compatibility issues
    opencode = {
      url = "github:anomalyco/opencode?ref=dev";
      # Don't follow nixpkgs - let it use its own
    };

    # VS Code Insiders - auto-updated hashes via GitHub Actions
    vscode-insiders = {
      url = "github:auguwu/vscode-insiders-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-native Spotify patching (avoids /nix/store write errors)
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, opencode, vscode-insiders, spicetify-nix, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs { 
        inherit system;
        config.allowUnfree = true;
        overlays = [ (import vscode-insiders) ];
      };

      # Wrap Caprine to use X11 for Vietnamese input support
      caprine-x11 = pkgs.runCommand "caprine-x11" {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      } ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.caprine}/bin/caprine $out/bin/caprine \
          --add-flags "--ozone-platform=x11"
      '';

      caprine-x11-desktop = pkgs.makeDesktopItem {
        name = "caprine";
        desktopName = "Caprine";
        comment = "Elegant Facebook Messenger desktop app";
        exec = "${caprine-x11}/bin/caprine %U";
        icon = "caprine";
        terminal = false;
        categories = [ "Network" "InstantMessaging" "Chat" ];
        mimeTypes = [ "x-scheme-handler/caprine" ];
        startupWMClass = "Caprine";
      };

      # Wrap vscode-insiders with FHS for extension support
      vscode-insiders-fhs = pkgs.buildFHSEnv {
        name = "code-insiders";
        targetPkgs = p: [
          pkgs.vscode-insiders
          # Required for extensions with native binaries
          p.stdenv.cc.cc.lib
          p.zlib
          p.openssl
          p.curl
          p.libsecret
          p.libkrb5
          p.icu
          # Network/auth for syncing
          p.glib
          p.nss
          p.nspr
          p.atk
          p.cups
          p.dbus
          p.expat
          p.libdrm
          p.libxkbcommon
          p.pango
          p.cairo
          p.mesa
          p.alsa-lib
          # Additional deps from wiki
          p.krb5
          p.libsoup_3
          p.webkitgtk_4_1
        ];
        runScript = "code-insiders";
        profile = ''
          export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
        '';
      };

      # Desktop entry for VS Code Insiders
      vscode-insiders-desktop = pkgs.makeDesktopItem {
        name = "code-insiders";
        desktopName = "Visual Studio Code - Insiders";
        comment = "Code Editing. Redefined.";
        exec = "${vscode-insiders-fhs}/bin/code-insiders %F";
        icon = "vscode-insiders";
        terminal = false;
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeTypes = [ "text/plain" "inode/directory" ];
        startupNotify = true;
        startupWMClass = "Code - Insiders";
      };

      # Antigravity Tools - launch AppImage via appimage-run
      antigravity-tools = let
        appimage = pkgs.fetchurl {
          url = "https://github.com/lbjlaq/Antigravity-Manager/releases/download/v4.1.21/Antigravity.Tools_4.1.21_amd64.AppImage";
          sha256 = "sha256-xszt6RUqBzHcvZEsahf8qwAAsmRGWGeE18yXAb/lbR8=";
        };
      in pkgs.writeShellScriptBin "antigravity-tools" ''
        exec ${pkgs.appimage-run}/bin/appimage-run ${appimage} "$@"
      '';

      # Desktop entry for Antigravity Tools
      antigravity-tools-desktop = pkgs.makeDesktopItem {
        name = "antigravity-tools";
        desktopName = "Antigravity Tools";
        comment = "AI API Management Tool";
        exec = "${antigravity-tools}/bin/antigravity-tools";
        icon = "antigravity_tools";
        terminal = false;
        categories = [ "Utility" "Development" ];
        mimeTypes = [ "text/plain" ];
        startupNotify = true;
        startupWMClass = "antigravity_tools";
      };

      # r2modman - launch AppImage via appimage-run
      r2modman = let
        appimage = pkgs.fetchurl {
          url = "https://github.com/ebkr/r2modmanPlus/releases/download/v3.2.14/r2modman-3.2.14.AppImage";
          sha256 = "sha256-KjKAzVyQgG8kXfhNmw8VfRco1pVhi3yGA81L+m1narU=";
        };
      in pkgs.writeShellScriptBin "r2modman" ''
        exec ${pkgs.appimage-run}/bin/appimage-run ${appimage} "$@"
      '';

      # Desktop entry for r2modman
      r2modman-desktop = pkgs.makeDesktopItem {
        name = "r2modman";
        desktopName = "r2modman";
        comment = "Thunderstore mod manager";
        exec = "${r2modman}/bin/r2modman";
        icon = "r2modman";
        terminal = false;
        categories = [ "Game" "Utility" ];
        startupNotify = true;
        startupWMClass = "r2modman";
      };

      # User configuration
      username = "phuctruong";
      hostname = "phuctruong-nixos";
    in
    {
      # NixOS system configuration
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/${hostname}/configuration.nix

          # Include Home Manager as a NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit spicetify-nix;
              };

              # Add plasma-manager to home-manager
              sharedModules = [
                plasma-manager.homeModules.plasma-manager
                spicetify-nix.homeManagerModules.spicetify
              ];

              users.${username} = import ./home/${username}.nix;
            };
          }

          # Extra packages from flake inputs
          ({ lib, pkgs, ... }: {
            # Enable nix-ld for VSCode extensions with pre-compiled binaries
            programs.nix-ld.enable = true;
            
            environment.systemPackages = lib.mkAfter [
              # From flake inputs
              opencode.packages.${system}.default
              # VS Code FHS - stable version with extension support
              pkgs.vscode.fhs
              # VS Code Insiders - bleeding edge with extension support (FHS wrapped)
              vscode-insiders-fhs
              vscode-insiders-desktop
              # AppImage runtime
              pkgs.appimage-run
              # Antigravity Tools
              antigravity-tools
              antigravity-tools-desktop
              # r2modman
              r2modman
              r2modman-desktop
              pkgs.gemini-cli
              # Custom packages
              caprine-x11
              caprine-x11-desktop
            ];
          })
        ];
      };

      # Standalone home-manager configuration (for systems without NixOS)
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          plasma-manager.homeModules.plasma-manager
          spicetify-nix.homeManagerModules.spicetify
          ./home/${username}.nix
        ];
      };

      # Development shells
      devShells.${system} =
        let
          mkPythonShell = python: pythonPackages: pkgs.mkShell {
            buildInputs = [
              python
              pkgs.uv
              pythonPackages.pip
              pythonPackages.setuptools
              pythonPackages.wheel
            ];
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nil # Nix LSP
              nixfmt-rfc-style
            ];
          };

          py312 = mkPythonShell pkgs.python312 pkgs.python312Packages;
          py313 = mkPythonShell pkgs.python313 pkgs.python313Packages;
          py314 = mkPythonShell pkgs.python314 pkgs.python314Packages;
          py315 = mkPythonShell pkgs.python315 pkgs.python315Packages;
        };
    };
}
