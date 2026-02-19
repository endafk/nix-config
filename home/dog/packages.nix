{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Dev
    vscode
    ripgrep
    jq
    python3
    # Term
    htop
    fastfetch
    btop    
    # Web
    firefox
    google-chrome
  ];
}
