{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono
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
    # OCR (needed by GNOME Text Grabber extension)
    (tesseract.override { enableLanguages = [ "eng" ]; })
    # System & USB
    gnome-tweaks
    usbutils      # lsusb
    pciutils      # lspci
    libimobiledevice  # ideviceinfo, idevicepair, etc.
    ifuse             # mount iPhone filesystem
    ideviceinstaller  # install/manage apps
    scrcpy            # mirror & control Android screen over USB
    android-tools     # adb + fastboot
    heimdall          # flash firmware on Samsung devices
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
    eza           # modern ls
    bat           # modern cat
    delta         # modern diff (used by git)
    fd            # modern find
    trash-cli     # safe rm → trash
    htop
    lazydocker
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
