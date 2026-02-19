{ ... }:

{
  home.shellAliases = {
    # NixOS
    rebuild  = "sudo nixos-rebuild switch --flake /home/dog/nix-config#nixos";
    update   = "nix flake update --flake /home/dog/nix-config";
    pacsearch = "nix search nixpkgs";

    # eza (ls replacement)
    ls  = "eza";
    ll  = "eza -l --git";
    la  = "eza -la --git";
    lt  = "eza --tree --level=2";

    # bat (cat replacement)
    cat = "bat --plain";
  };
}
