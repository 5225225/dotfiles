{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    blank.url = "github:divnix/blank";
    # nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    base16.url = "github:SenchoPens/base16.nix";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";

        # NOTE: With the "keep flake inputs" thing
        # (https://github.com/NixOS/nix/issues/3995#issuecomment-2081164515)
        # you *cannot* use just "" to blank out a dependency.
        # so use blank (defined above) here.
        # https://matrix.to/#/!RRerllqmbATpmbJgCn:nixos.org/$GL3qXaUWqtKjPo09zZ-dElwUIz_oIXc02nZdVgNzrio?via=lossy.network&via=matrix.org&via=tchncs.de
        darwin.follows = "blank";
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
    { self, nixpkgs, ... }@inputs':
    let
      inputs = inputs' // {
        firefox-addons = inputs'.firefox-addons.packages.x86_64-linux;
        # nixos-unstable-small = (import inputs'.nixos-unstable-small) { system = "x86_64-linux"; };
      };

      treefmtEval = inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.x86_64-linux ./treefmt.nix;

      collectFlakeInputs =
        input:
        [ input ] ++ builtins.concatMap collectFlakeInputs (builtins.attrValues (input.inputs or { }));

      extraDeps = builtins.concatMap collectFlakeInputs (builtins.attrValues inputs') ++ [
        self.formatter.x86_64-linux
        self.checks.x86_64-linux.check
      ];
    in
    {
      nixosConfigurations.iridium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          system/configuration.nix
          { system.extraDependencies = extraDeps; }
        ];
        specialArgs = {
          inherit inputs;
          inherit self;
        };
      };

      templates = {
        rust = {
          path = ./templates/rust;
          description = "A rust scratch project template";
          welcomeText = ''
            🩵🩷🤍🩷🩵\
            🩵🩷🤍🩷🩵\
            🩵🩷🤍🩷🩵

            💛💛💛💛\
            🤍🤍🤍🤍\
            💜💜💜💜\
            🖤🖤🖤🖤
          '';
        };
      };

      formatter.x86_64-linux = treefmtEval.config.build.wrapper;
      checks.x86_64-linux.check = treefmtEval.config.build.check self;

      packages.x86_64-linux.update = nixpkgs.legacyPackages.x86_64-linux.writeShellApplication {
        name = "update-system";
        inheritPath = false;
        runtimeInputs = [ self.packages.x86_64-linux.diff ];
        text = ''
          nix flake update --commit-lock-file
          diff-system HEAD^ HEAD
        '';
      };

      packages.x86_64-linux.diff =
        let
          np = nixpkgs.legacyPackages.x86_64-linux;
        in
        np.writeShellApplication {
          name = "diff-system";
          runtimeInputs = [
            np.git
            np.coreutils
            np.lix
            np.nix-output-monitor
            np.nix-diff
          ];
          inheritPath = false;
          text = ''
            old_rev="''${1-HEAD~1}"
            new_rev="''${1-HEAD}"

            old_hash=$(git rev-parse "$old_rev")
            new_hash=$(git rev-parse "$new_rev")

            echo "$old_rev ($old_hash) -> "
            echo "$new_rev ($new_hash)"

            OUT_DIR=$(mktemp -d)
            OUT_LINK="$OUT_DIR/build"

            toplevel="nixosConfigurations.iridium.config.system.build.toplevel"

            nix build "./?rev=$old_hash#$toplevel" "./?rev=$new_hash#$toplevel" --out-link "$OUT_LINK" --log-format internal-json -v |& nom --json

            nix store diff-closures "$OUT_LINK" "$OUT_LINK-1"

            if [ "''${3:-normal}" == "verbose" ]; then
                nix-diff --skip-already-compared --character-oriented "$OUT_LINK" "$OUT_LINK-1"
            fi
          '';
        };
    };
}
