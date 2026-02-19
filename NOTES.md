# NixOS Quick Reference

## Everyday Commands

```bash
# Rebuild and switch to new config
sudo nixos-rebuild switch --flake /home/dog/nix-config#nixos
# or just use the alias:
rebuild

# Rebuild but don't switch yet (test first)
sudo nixos-rebuild test --flake /home/dog/nix-config#nixos

# Update all flake inputs (nixpkgs + home-manager)
nix flake update

# Update only nixpkgs
nix flake update nixpkgs

# Garbage collect old generations (free disk space)
sudo nix-collect-garbage -d

# List system generations (rollback points)
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

## Where Things Live

```
flake.nix                           # Entry point — inputs & module wiring
flake.lock                          # Pinned versions (don't edit by hand)
hosts/nixos/configuration.nix       # System-level config (services, boot, users)
hosts/nixos/hardware-configuration.nix  # Auto-generated hardware — don't edit
home/dog/home.nix                   # User config (packages, dotfiles, shell)
```

## System vs Home Manager — What Goes Where?

| **System (configuration.nix)**       | **Home Manager (home.nix)**         |
|--------------------------------------|-------------------------------------|
| Services (docker, pipewire, gdm)     | User apps (firefox, vscode, htop)   |
| Boot, kernel, networking             | Dotfiles (.bashrc, .gitconfig)      |
| System users & groups                | Shell aliases & environment vars    |
| Drivers & firmware                   | Per-user program config             |
| `environment.systemPackages`         | `home.packages`                     |

**Rule of thumb**: If it needs `sudo` or affects all users, it's system config. Everything else goes in Home Manager.

## Searching for Packages

```bash
# Search nixpkgs for a package
nix search nixpkgs firefox

# Browse packages online
# https://search.nixos.org/packages

# Browse options online
# https://search.nixos.org/options
```

## Adding a Package

**User app** — add to `home.packages` in `home/dog/home.nix`:
```nix
home.packages = with pkgs; [
  firefox
  spotify  # just add it here
];
```

**System tool** — add to `environment.systemPackages` in `hosts/nixos/configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  some-system-tool  # add here
];
```

Then run `rebuild`.

## Configuring Programs Declaratively

Instead of just installing a package, you can use a `programs.<name>` module for deeper config. Example:

```nix
# Instead of just putting "git" in home.packages:
programs.git = {
  enable = true;              # installs git
  userName = "your-name";
  userEmail = "you@email.com";
  extraConfig = {
    init.defaultBranch = "main";
    pull.rebase = true;
  };
};
```

Find available program modules: https://nix-community.github.io/home-manager/options.xhtml

## Common Gotchas

- **Don't edit `hardware-configuration.nix`** — it's auto-generated. Regenerate with `nixos-generate-config`.
- **`stateVersion` should never change** — it's not your NixOS version. It tells NixOS what defaults to use for backward compat. Leave it as-is.
- **Unfree packages** need `nixpkgs.config.allowUnfree = true` (already set).
- **After `nix flake update`**, always rebuild to apply the new versions.
- **If a rebuild fails**, your system stays on the old working config. Nothing breaks.

## Useful Nix Resources

- NixOS Options: https://search.nixos.org/options
- Nix Packages: https://search.nixos.org/packages
- Home Manager Options: https://nix-community.github.io/home-manager/options.xhtml
- Nix Pills (learn Nix language): https://nixos.org/guides/nix-pills/
- Zero to Nix: https://zero-to-nix.com/
