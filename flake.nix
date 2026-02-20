{
  description = "Tone NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-vscode-extensions,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        nix-vscode-extensions.overlays.default
      ];
    };
  in {
    packages.${system}.helium = pkgs.callPackage ./pkgs/helium.nix {};

    nixosConfigurations = {
      tone = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "home-manager-backup";
              extraSpecialArgs = {inherit pkgs;};
              users.alex = ./home.nix;
            };
          }

          {
            environment.systemPackages = with pkgs; [
              self.packages.${system}.helium
            ];
          }
        ];
      };
    };
  };
}
