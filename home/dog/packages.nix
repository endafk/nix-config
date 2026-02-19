{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Dev
    vscode
    ripgrep
    jq
    python3
    go
    # DevOps / SRE
    kubectl
    kubernetes-helm
    terraform
    ansible
    docker-compose
    k9s
    lens
    awscli2
    # Networking & Debug
    curl
    dig
    nmap
    traceroute
    # Term
    htop
    btop
    fastfetch
    tmux
    fzf
    yq-go
    # Web
    firefox
    google-chrome
  ];
}
