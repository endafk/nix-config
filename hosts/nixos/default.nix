{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./adguard.nix
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
    options = "--delete-older-than 7d";    # remove generations older than 1 week
  };
  nix.settings.auto-optimise-store = true; # dedup the store via hard links

  # Coredump — cap storage so crash dumps don't eat disk
  systemd.coredump.extraConfig = ''
    Storage=external
    MaxUse=128M
    ProcessSizeMax=64M
  '';

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

  # Remove GNOME bloat
  environment.gnome.excludePackages = with pkgs; [
    epiphany              # web browser
    geary                 # email
    gnome-music
    gnome-tour
    gnome-contacts
    gnome-maps
    totem                 # video player (we have vlc)
    yelp                  # help viewer
    simple-scan
  ];

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
  # Disable wait online service
  # systemd.services.NetworkManager-wait-online.enable = False
	
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

  # Samba — expose ~/Documents/Shared_Folder as "nixos"
  services.samba = {
    enable = true;
    openFirewall = true;                   # opens 139 + 445
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "nixos";
        security = "user";
        "map to guest" = "never";
      };
      nixos = {
        path = "/home/dog/Documents/Shared_Folder";
        browseable = "yes";
        "read only" = "no";
        "valid users" = "dog";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # Samba discovery on the local network (wsdd)
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  # Cups For print Support
  services.printing.enable = true;
  # Avahi for resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  # flatpak
  services.flatpak.enable = true;


  # Firewall — open port 8080 for local dev servers
  networking.firewall.allowedTCPPorts = [ 8080 ];

  services.adguardhome = {
  enable = true;
  openFirewall = true; # Opens TCP/UDP 53 and TCP 3000 for the UI
  };
  # Force the local system to query the local AdGuard daemon
  networking.nameservers = [ "127.0.0.1" ];

  # Castrate NetworkManager so DHCP leases don't overwrite your DNS settings
  networking.networkmanager.dns = "none";

  # Kill systemd-resolved
  services.resolved.enable = false;

  # Force standard resolv.conf generation pointing strictly to AdGuard
  environment.etc."resolv.conf".text = ''
    nameserver 127.0.0.1
    options edns0 trust-ad
  '';

  # FLAKES CONFIG (Critical)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages (Chrome, VSCode, Drivers)
  nixpkgs.config.allowUnfree = true;

  # System Packages (Keep this small. Use Home Manager for apps.)
  environment.systemPackages = with pkgs; [
    vim
    wget
    git       # available before Home Manager activates
  ];

  system.stateVersion = "24.05"; 
}
