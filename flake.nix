{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixvim = {
      url = "github:nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-colors,
      base16-vim,
      vim-capnp,
      nix-index-database,
      agenix,
      nixvim,
      lix-module,
      firefox-addons,
      treefmt-nix,
    }:
    let
      treefmtEval = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.x86_64-linux ./treefmt.nix;
    in
    {
      nixosConfigurations.iridium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            system.configurationRevision = self.rev or "dirty";
            programs.command-not-found.enable = false;
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
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
              inherit agenix;
              inherit nixvim;
              firefox-addons = firefox-addons.packages.x86_64-linux;
            };
          }
        ];
      };

      formatter.x86_64-linux = treefmtEval.config.build.wrapper;
      checks.x86_64-linux.check = treefmtEval.config.build.check self;

      /*
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
              p.statix
            ];
          } ''
            shfmt --diff --indent 4 --space-redirects "$src"
            alejandra --quiet --check "$src" || (echo "Alejandra formatting failed" ; exit 1)
            deadnix --fail "$src"
            statix check "$src"

            touch $out;
            '';
      */
    };
}
