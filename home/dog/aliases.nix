{ ... }:

{
  home.shellAliases = {
    # NixOS
    rebuild   = "sudo nixos-rebuild switch --flake /home/dog/nix-config#nixos";
    update    = "nix flake update --flake /home/dog/nix-config";
    pacsearch = "nix search nixpkgs";

    # eza (ls replacement)
    ls = "eza";
    ll = "eza -l --git";
    la = "eza -la --git";
    lt = "eza --tree --level=2";

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
