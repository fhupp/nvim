{
  description = "A Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    direnv-nvim-src = {
      url = "github:NotAShelf/direnv.nvim";
      flake = false;
    };

    ltex-ls-nvim-src = {
      url = "github:vigoux/ltex-ls.nvim";
      flake = false;
    };

    neominimap-nvim-src = {
      url = "github:Isrothy/neominimap.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      neovim,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      eachSystem = nixpkgs.lib.genAttrs systems;

      neovim-overlay = import ./neovim-overlay.nix { inherit inputs; };
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = import nixpkgs {
            # config.allowUnfree = true;
            inherit system;
            overlays = [
              neovim.overlays.default
              neovim-overlay
            ];
          };
        in
        rec {
          inherit (pkgs) nvim;

          default = nvim;
        }
      );

      apps = eachSystem (system: rec {
        nvim = {
          type = "app";
          program = "${self.packages.${system}.nvim}/bin/nvim";
        };

        default = nvim;
      });

      nixosModules = eachSystem (system: {
        default = import ./nixosModule.nix { inherit (self.packages.${system}) nvim; };
      });

      overlays.default = neovim-overlay;
    };
}
