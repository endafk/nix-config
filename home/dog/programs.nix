{ ... }:

{
  # Git
  programs.git = {
    enable = true;
    userName = "endafk";
    userEmail = "254jaymz@gmail.com";
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
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch --flake /home/dog/nix-config#nixos";
    };
  };
}
