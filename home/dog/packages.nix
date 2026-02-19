{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Dev
    vscode
    antigravity
    ripgrep
    jq
    python3
    go
    nodejs
    yarn
    pnpm
    # DevOps / SRE
    kubectl
    kubernetes-helm
    terraform
    ansible
    docker-compose
    k9s
    lens
    awscli2
    # Networking & Security
    bettercap
    mtr
    curl
    dig
    nmap
    traceroute
    wifite2
    wireshark
    # System & USB
    usbutils      # lsusb
    pciutils      # lspci
    file
    unzip
    p7zip
    # Media
    ffmpeg
    vlc
    obs-studio
    parabolic     # yt-dlp frontend
    gapless       # music player
    # Term
    htop
    btop
    fastfetch
    tmux
    fzf
    yq-go
    # Apps
    bitwarden-desktop
    # Web
    zapzap
    firefox
    google-chrome
  ];
}
