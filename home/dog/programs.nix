{ ... }:

{
  # Git
  programs.git = {
    enable = true;
    userName = "endafk";
    userEmail = "254jaymz@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Shell
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake /home/dog/nix-config#nixos";
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kga = "kubectl get all";
      kns = "kubectl config set-context --current --namespace";
      tf = "terraform";
      dc = "docker-compose";
      dps = "docker ps";
    };
  };

  # Direnv (auto-load .envrc per project)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
