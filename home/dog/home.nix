{ config, pkgs, ... }:

{
  home.username = "dog";
  home.homeDirectory = "/home/dog";

  # User Packages
  home.packages = with pkgs; [
    # Dev
    vscode
    ripgrep
    jq
    neovim
    
    # Term
    htop
    fastfetch
    
    # Web
    firefox
    google-chrome
  ];

  # Basic Git Config
  programs.git = {
    enable = true;
    userName = "dog";
    userEmail = "change_me@example.com";
  };

  # Shell Config
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch --flake /home/dog/nix-config#nixos";
    };
  };

  home.stateVersion = "24.05";
}
