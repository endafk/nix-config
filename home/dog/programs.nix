{ pkgs, ... }:

{
  # Git
  programs.git = {
    enable = true;
    userName = "endafk";
    userEmail = "254jaymz@gmail.com";
    delta = {
      enable = true;                     # pretty diffs with syntax highlighting
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictstyle = "zdiff3";    # clearer conflict markers
      diff.algorithm = "histogram";      # better diff output
      rerere.enabled = true;             # remember conflict resolutions
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
    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # Better history search with up/down arrows
      bind \e\[A history-search-backward
      bind \e\[B history-search-forward
    '';
  };

  # Starship prompt (cross-shell, nerd font icons, git/k8s/language context)
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings = {
      format = "$directory$git_branch$git_status$kubernetes$python$golang$nodejs$terraform$docker_context$cmd_duration$line_break$character";
      character = {
        success_symbol = "[λ](green)";
        error_symbol = "[λ](red)";
      };
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        style = "cyan bold";
      };
      git_branch = {
        format = "on [$symbol$branch]($style) ";
        style = "purple";
      };
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "red";
      };
      kubernetes = {
        disabled = false;
        format = "on [⎈ $context/$namespace]($style) ";
        style = "blue";
      };
      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "yellow";
      };
      python.format = "via [\${symbol}\${version}]($style) ";
      golang.format = "via [\${symbol}\${version}]($style) ";
      nodejs.format = "via [\${symbol}\${version}]($style) ";
      terraform.format = "via [\${symbol}\${version}]($style) ";
      docker_context.format = "via [\${symbol}\${context}]($style) ";
    };
  };

  # Tmux
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;                       # windows start at 1
    escapeTime = 0;                      # no delay on Esc
    historyLimit = 50000;
    extraConfig = ''
      # Split with | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Navigate panes with Alt+arrow (no prefix)
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"

      # Status bar
      set -g status-position top
      set -g status-style "bg=default,fg=white"
    '';
  };

  # Direnv (auto-load .envrc per project)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # fzf (fuzzy finder integration with shell)
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    defaultCommand = "rg --files --hidden --glob '!.git'";
    defaultOptions = [ "--height=40%" "--layout=reverse" "--border" ];
  };
}
