{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    base16-vim = {
      url = "github:tinted-theming/base16-vim";
      flake = false;
    };
    git-prompt = {
      url = "github:woefe/git-prompt.zsh";
      flake = false;
    };
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nix-colors
    , base16-vim
    , git-prompt
    , flake-registry
    , nix-index-database
    ,
    }: {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            system.configurationRevision = self.rev;

            # pin nixpkgs to system nixpkgs for determinism
            nix.registry.nixpkgs.flake = nixpkgs; # For flake commands

            # thanks to
            # https://discourse.nixos.org/t/24093/8
            nix.nixPath = [ "/etc/nix/path" ]; # For legacy commands
            environment.etc."nix/path/nixpkgs".source = nixpkgs;

            # thanks to
            # https://discourse.nixos.org/t/32003/3
            nix.settings.flake-registry = "${flake-registry}/flake-registry.json";

            programs.command-not-found.enable = false;
          }
          system/configuration.nix
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jess = import user/home.nix;

            home-manager.extraSpecialArgs = {
              inherit nix-colors;
              inherit base16-vim;
              inherit git-prompt;
              inherit nix-index-database;
            };
          }
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
