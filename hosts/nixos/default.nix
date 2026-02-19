{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader (Standard systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
