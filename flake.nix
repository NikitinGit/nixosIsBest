{
  description = "dfjay flake config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    hyprland.url = "github:hyprwm/Hyprland";

    mac-app-util.url = "github:hraban/mac-app-util";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-vscode-extensions, stylix, disko, impermanence, hyprland, mac-app-util, nix-flatpak, ... }:
  {
    nixosConfigurations = {
      dfjay-desktop = 
        let
          username = "igor";  
          useremail = "andnikitn5@gmail.com";
          hostname = "igor-desktop";
          userdesc = "Igor Nikitin";
          specialArgs = inputs // { inherit inputs username useremail hostname userdesc; };        
        in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ({ pkgs, lib, ... }: {
              nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];
            })
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            ./hosts/desktop
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${username} = import ./hosts/desktop/home.nix;
            }
          ];
        };
    };
  };
}
