{ config, pkgs, ... }:

{
  imports = [
    ./aliases.nix
    ./gnome.nix
    ./packages.nix
    ./programs.nix
  ];

  home.username = "dog";
  home.homeDirectory = "/home/dog";

  # Cursor
  home.pointerCursor = {
    name = "Bibata-Modern-Amber";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.stateVersion = "24.05";
}
