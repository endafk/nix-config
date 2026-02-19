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
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ]; 
  };

  # Docker
  virtualisation.docker.enable = true;

  # Wireshark (needs system-level group for packet capture)
  programs.wireshark.enable = true;

  # LocalSend (opens firewall port 53317 for discovery + transfer)
  programs.localsend.enable = true;

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
