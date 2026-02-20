{ lib, ... }:

{
  # GNOME desktop tweaks via dconf
  dconf.settings = {

    # Interface
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      clock-show-seconds = false;
      monospace-font-name = "JetBrainsMono Nerd Font 11";
    };

    # Touchpad (natural scroll, tap-to-click)
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    # Window management
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    # Power — don't suspend on AC
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };

    # Nautilus — list view, show hidden files
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-hidden-files = true;
    };

  };
}
