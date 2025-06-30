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
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ripnixsearch = {
      url = "git+https://codeberg.org/5225225/ripnixsearch";
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

      np = nixpkgs.legacyPackages.x86_64-linux;
      lix = inputs.lix-module.pkgs.x86_64-linux.lix;

      welcomeText = ''
        🩵🩷🤍🩷🩵\
        🩵🩷🤍🩷🩵\
        🩵🩷🤍🩷🩵

        💛💛💛💛\
        🤍🤍🤍🤍\
        💜💜💜💜\
        🖤🖤🖤🖤
      '';
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
          inherit welcomeText;
        };
        rustproject = {
          path = ./templates/rustproject;
          description = "A template based of crane's quickstart";
          inherit welcomeText;
        };
      };

      formatter.x86_64-linux = treefmtEval.config.build.wrapper;
      checks.x86_64-linux.check = treefmtEval.config.build.check self;

      packages.x86_64-linux.update = np.writeShellApplication {
        name = "update-system";
        inheritPath = false;
        runtimeInputs = [
          self.packages.x86_64-linux.diff
          self.packages.x86_64-linux.diff-relnotes
          np.nix-output-monitor
          np.coreutils
          lix
          np.git
        ];
        text = ''
          toplevel="nixosConfigurations.iridium.config.system.build.toplevel"
          OUT_DIR=$(mktemp -d)
          OUT_LINK="$OUT_DIR/build"

          if ! (git diff --exit-code >/dev/null 2>&1 && git diff --staged --exit-code >/dev/null 2>&1);
          then
            echo "Refusing to update with a dirty repo";
            exit 1;
          fi

          nix flake update
          if nix build "./#$toplevel" --out-link "$OUT_LINK" --log-format internal-json -v |& nom --json;
          then
            git restore flake.lock
            nix flake update --commit-lock-file
            diff-system HEAD^ HEAD
            diff-relnotes HEAD^ HEAD
          else
            git restore flake.lock
          fi
        '';
      };

      packages.x86_64-linux.diff-relnotes =
        let
          np = nixpkgs.legacyPackages.x86_64-linux;
        in
        np.writeShellApplication {
          name = "diff-relnotes";
          runtimeInputs = [
            np.git
            np.delta
            lix
            np.jq
          ];
          inheritPath = false;
          text = ''
            old_rev="''${1-HEAD~1}"
            new_rev="''${2-HEAD}"

            old_hash=$(git rev-parse "$old_rev")
            new_hash=$(git rev-parse "$new_rev")

            old_src="$(nix flake metadata --inputs-from "./?rev=$old_hash" nixpkgs --json | jq -r .path)"
            new_src="$(nix flake metadata --inputs-from "./?rev=$new_hash" nixpkgs --json | jq -r .path)"

            relnotes_path="/nixos/doc/manual/release-notes/"

            old_relnotes="$old_src$relnotes_path"
            new_relnotes="$new_src$relnotes_path"

            delta --paging never "$old_relnotes" "$new_relnotes"
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
            lix
            np.nix-output-monitor
            np.nix-diff
          ];
          inheritPath = false;
          text = ''
            old_rev="''${1-HEAD~1}"
            new_rev="''${2-HEAD}"

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
