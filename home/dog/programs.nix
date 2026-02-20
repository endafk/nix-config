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
      # Silence
      set -g fish_greeting

      # History search with arrows
      bind \e\[A history-search-backward
      bind \e\[B history-search-forward

      # Color tweaks
      set -g fish_color_command green
      set -g fish_color_param normal
      set -g fish_color_error red --bold
      set -g fish_color_comment brblack
      set -g fish_color_autosuggestion brblack
      set -g fish_color_valid_path --underline
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings = {
      format = builtins.concatStringsSep "" [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$kubernetes"
        "$docker_context"
        "$python"
        "$golang"
        "$nodejs"
        "$terraform"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      # Prompt char — clean arrow, red on fail
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold blue)";
      };

      # Only show user@host over SSH
      username = {
        show_always = false;
        format = "[$user]($style)@";
        style_user = "bold yellow";
      };
      hostname = {
        ssh_only = true;
        format = "[$hostname]($style) in ";
        style = "bold yellow";
      };

      # Directory
      directory = {
        truncation_length = 4;
        truncate_to_repo = true;
        style = "bold cyan";
        read_only = " 󰌾";
      };

      # Git
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        style = "bold purple";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        stashed = "≡";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        conflicted = "=\${count}";
        deleted = "✘\${count}";
        renamed = "»\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        untracked = "?\${count}";
      };

      # Infra
      kubernetes = {
        disabled = false;
        symbol = "⎈ ";
        format = "[$symbol$context(/$namespace)]($style) ";
        style = "bold blue";
      };
      docker_context = {
        symbol = " ";
        format = "[$symbol$context]($style) ";
        style = "blue";
        only_with_files = true;
      };
      terraform = {
        symbol = "󱁢 ";
        format = "[$symbol$version]($style) ";
        style = "bold 105";
      };

      # Languages — only show when relevant files detected
      python = {
        symbol = " ";
        format = "[$symbol$version(\($virtualenv\))]($style) ";
        style = "bold yellow";
      };
      golang = {
        symbol = " ";
        format = "[$symbol$version]($style) ";
        style = "bold cyan";
      };
      nodejs = {
        symbol = " ";
        format = "[$symbol$version]($style) ";
        style = "bold green";
      };

      # Nix shell indicator
      nix_shell = {
        symbol = " ";
        format = "[$symbol$state]($style) ";
        style = "bold blue";
      };

      # Slow command timer
      cmd_duration = {
        min_time = 1500;
        format = "[took $duration]($style) ";
        style = "bold yellow";
      };
    };
  };

  # Tmux
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    extraConfig = ''
      # ── Prefix ──
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      # ── Splits ──
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # ── Pane nav (Alt+arrow, no prefix) ──
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # ── Resize (prefix + Shift+arrow) ──
      bind -r S-Left resize-pane -L 2
      bind -r S-Right resize-pane -R 2
      bind -r S-Up resize-pane -U 2
      bind -r S-Down resize-pane -D 2

      # ── Windows ──
      bind c new-window -c "#{pane_current_path}"
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5

      # ── Reload ──
      bind r source-file ~/.config/tmux/tmux.conf \; display " Reloaded"

      # ── Visual ──
      set -g status-position top
      set -g status-interval 5
      set -g status-style "fg=#a0a0a0,bg=default"
      set -g status-left "#[bold,fg=blue] #S "
      set -g status-left-length 20
      set -g status-right "#[fg=#606060]%H:%M"
      set -g status-right-length 10

      setw -g window-status-format "#[fg=#606060] #I:#W "
      setw -g window-status-current-format "#[bold,fg=green] #I:#W "

      set -g pane-border-style "fg=#303030"
      set -g pane-active-border-style "fg=#505050"

      set -g message-style "fg=yellow,bg=default"

      # ── True color ──
      set -as terminal-features ",xterm-256color:RGB"
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
