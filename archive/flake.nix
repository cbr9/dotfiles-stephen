{
  # https://nixos.org/manual/nixos/stable/
  # https://github.com/ryan4yin/nixos-and-flakes-book
  description = "Stephen's NixOS Flake";

  inputs = {
    # Current version nix package source
    nixpkgs.url = "github:nixOS/nixpkgs/nixos-23.05";
    # unstable nix package source
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager, used for managing user configuration
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # Helix editor, using version 23.05
    helix.url = "github:helix-editor/helix/23.05";
  };

   outputs = inputs@{ self, nixpkgs,nixpkgs-unstable, home-manager, ... }: {
    nixosConfigurations = {
      # Configuration for dev-config
      "dev-config" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./configuration.nix

          # install home-manager as a nixos module
          # home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.stephen = import ./home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
