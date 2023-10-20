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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-colors,
    base16-vim,
    git-prompt,
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jess = import ../user/home.nix;

          home-manager.extraSpecialArgs = {
            inherit nix-colors;
            inherit base16-vim;
            inherit git-prompt;
          };
        }
      ];
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
