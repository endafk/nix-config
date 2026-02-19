{ config, pkgs, ... }:

{
  imports = [
    ./aliases.nix
    ./packages.nix
    ./programs.nix
  ];

  home.username = "dog";
  home.homeDirectory = "/home/dog";

  home.stateVersion = "24.05";
}
