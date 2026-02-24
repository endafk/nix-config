{ ... }:

{
  home.shellAliases = {
    # NixOS
    rebuild   = "sudo nixos-rebuild switch --flake /home/dog/nix-config#nixos";
    update    = "nix flake update --flake /home/dog/nix-config";
    pacsearch = "nix search nixpkgs";

    # eza (ls replacement)
    ls = "eza --icons";
    ll = "eza -l --git --icons";
    la = "eza -la --git --icons";
    lt = "eza --tree --level=2 --icons";

    # bat (cat replacement)
    cat = "bat --plain";

    # safety
    rm = "trash-put";           # move to trash instead of delete

    # misc
    ".." = "cd ..";
    "..." = "cd ../..";
    grep = "grep --color=auto";
    df = "df -h";
    du = "du -h";
    ip = "ip -color=auto";
  };
}
