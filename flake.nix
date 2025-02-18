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
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
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
    lix-module,
  }: {
    nixosConfigurations.iridium = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          system.configurationRevision = self.rev or "dirty";
          programs.command-not-found.enable = false;
          environment.systemPackages = [agenix.packages.x86_64-linux.default];
        }
        system/configuration.nix
        nix-index-database.nixosModules.nix-index
        agenix.nixosModules.default
        lix-module.nixosModules.default
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
      ${nixpkgs.legacyPackages.x86_64-linux.shfmt}/bin/shfmt --write --indent 4 --space-redirects .
    '';

    checks.x86_64-linux.check =
      nixpkgs.legacyPackages.x86_64-linux.runCommandLocal "check" {
        src = ./.;
        nativeBuildInputs = let
          p = nixpkgs.legacyPackages.x86_64-linux;
        in [
          p.shfmt
          p.alejandra
          p.deadnix
        ];
      } ''
        shfmt --diff --indent 4 --space-redirects "$src"
        alejandra --quiet --check "$src" || (echo "Alejandra formatting failed" ; exit 1)
        deadnix --fail "$src"

        touch $out;
      '';
  };
}
