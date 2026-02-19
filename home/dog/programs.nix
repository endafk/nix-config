{ pkgs, ... }:

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

  # Bash
  programs.bash.enable = true;

  # Fish
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "theme-lambda";
        src = pkgs.fetchFromGitHub {
          owner = "hasanozgan";
          repo = "theme-lambda";
          rev = "a7cb6dbaee9e9dcbe7fea02b92fc85fb2d278869";
          sha256 = "1fc1h675gww2xd3jhm4iv2pki5k6j5nnyrmvfs943jx49r2xrhhs";
        };
      }
    ];
  };

  # Direnv (auto-load .envrc per project)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
