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
    git
    python
    # Term
    htop
    fastfetch
    btop    
    # Web
    firefox
    google-chrome
  ];

  # Basic Git Config
  programs.git = {
    enable = true;
    userName = "endafk";
    userEmail = "254jaymz@gmail.com";
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
