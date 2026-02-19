{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader (Standard systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # keep last 10 generations
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1; # 1 second boot menu

  # Boot Splash (spinning NixOS logo)
  boot.plymouth = {
    enable = true;
    theme = "nixos-bgrt";
    themePackages = [ pkgs.nixos-bgrt-plymouth ];
  };
  boot.consoleLogLevel = 0;                          # suppress kernel messages
  boot.initrd.verbose = false;                       # quiet initrd
  boot.kernelParams = [ "quiet" "splash" "udev.log_level=3" ];

  # ThinkPad T480s
  services.thermald.enable = true;         # Intel thermal management
  services.fwupd.enable = true;            # firmware updates via LVFS
  hardware.bluetooth.enable = true;        # ThinkPad bluetooth
  hardware.bluetooth.powerOnBoot = true;

  # Nix Store Cleanup
  nix.gc = {
    automatic = true;
    dates = "weekly";                      # runs every week
    options = "--delete-older-than 14d";   # remove generations older than 2 weeks
  };
  nix.settings.auto-optimise-store = true; # dedup the store via hard links

  # Networking
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;

  # Time & Locale
  time.timeZone = "Africa/Nairobi";
  i18n.defaultLocale = "en_US.UTF-8";

  # GNOME Desktop
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Audio (Pipewire is the only correct choice)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # User Account
  users.users.dog = {
    isNormalUser = true;
    description = "dog";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ]; 
  };

  # Enable fish at system level (adds it to /etc/shells)
  programs.fish.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Wireshark (needs system-level group for packet capture)
  programs.wireshark.enable = true;

  # iPhone USB (usbmuxd + libimobiledevice)
  services.usbmuxd.enable = true;

  # LocalSend (opens firewall port 53317 for discovery + transfer)
  programs.localsend.enable = true;

  # nix-ld (lets pip/venv binaries find C libraries without patching)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core
    stdenv.cc.cc.lib          # libstdc++ — needed by almost everything
    zlib                      # compression (numpy, pandas, pip itself)

    # Crypto & networking (cryptography, requests, urllib3, werkzeug)
    openssl
    libffi
    curl

    # Data/science (numpy, scipy, pandas, openpyxl)
    bzip2
    xz                        # lzma compression
    readline
    sqlite

    # XML/HTML parsing (lxml, openpyxl, defusedxml)
    libxml2
    libxslt
    expat

    # Image handling (Pillow, matplotlib)
    libGL
    freetype
    libpng
    libjpeg
    libtiff
    lcms2
    libwebp
    openjpeg

    # GUI / fonts (matplotlib backends, tkinter)
    glib
    icu
    ncurses
    tk
    harfbuzz
  ];

  # Make nix-ld libraries visible to Python dlopen() (numpy, pandas, etc.)
  environment.variables.LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";

  # Firewall — open port 8080 for local dev servers
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # FLAKES CONFIG (Critical)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages (Chrome, VSCode, Drivers)
  nixpkgs.config.allowUnfree = true;

  # System Packages (Keep this small. Use Home Manager for apps.)
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "24.05"; 
}
