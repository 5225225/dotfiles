{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    base16-vim = {
      url = "github:tinted-theming/tinted-vim";
      flake = false;
    };
    vim-capnp = {
      url = "github:cstrahan/vim-capnp";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
        home-manager.follows = "home-manager";
      };
    };
    idris2-nvim = {
      url = "github:ShinKage/idris2-nvim";
      flake = false;
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-colors,
    base16-vim,
    vim-capnp,
    nix-index-database,
    agenix,
    idris2-nvim,
    nixvim,
  }: {
    nixosConfigurations.iridium = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          system.configurationRevision = self.rev;
          programs.command-not-found.enable = false;
          environment.systemPackages = [agenix.packages.x86_64-linux.default];
        }
        system/configuration.nix
        nix-index-database.nixosModules.nix-index
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.fivie = import user/home.nix;
          };

          home-manager.extraSpecialArgs = {
            inherit nix-colors;
            inherit base16-vim;
            inherit vim-capnp;
            inherit nix-index-database;
            inherit idris2-nvim;
            inherit agenix;
            inherit nixvim;
          };
        }
      ];
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.writeShellScriptBin "formatter" ''
      ${nixpkgs.legacyPackages.x86_64-linux.alejandra}/bin/alejandra --quiet "''${@-.}"
    '';
  };
}
