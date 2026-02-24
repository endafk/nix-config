{
  description = "NixOS Configuration";

  inputs = {
    # Pinned to the 25.11 stable release branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    
    # Home Manager MUST match the nixpkgs branch
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dog = import ./home/dog;
          }
        ];
      };
    };
  };
}