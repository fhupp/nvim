{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  mkNvimPlugin = import ./mkNvimPlugin.nix {
    inherit (pkgs) vimUtils;
  };

  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  all-plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars

    nvim-web-devicons

    (mkNvimPlugin inputs.direnv-nvim-src "direnv.nvim")
    (mkNvimPlugin inputs.neominimap-nvim-src "neominimap.nvim")

    # Lazy Loading
    lze
    lzextras

    # Colorschemes
    vim-moonfly-colors

    # Picker
    telescope-nvim

    # Images
    image-nvim

    # Git
    gitsigns-nvim
    neogit
    mini-diff

    # QoL
    autosave-nvim

    # Completions
    blink-cmp

    # Tab Bar
    bufferline-nvim

    # Status Line
    lualine-nvim

    # Startpage
    alpha-nvim

    # File Systems
    oil-nvim
    neo-tree-nvim

    # Browser Integration
    firenvim

    # LSP
    lsp-format-nvim

    # LaTeX
    vimtex
    # (mkNvimPlugin inputs.ltex-ls-nvim-src "ltex-ls.nvim")
    ltex_extra-nvim

    # Haskell
    haskell-tools-nvim

    # Lean
    lean-nvim

    # Rust
    crates-nvim
  ];

  extraPackages = with pkgs; [
    # LSPs
    ## Nix
    nil
    nixd

    ## Lua
    lua-language-server

    ## LaTeX
    ltex-ls

    ## Rust
    rust-analyzer

    ## Haskell
    haskellPackages.haskell-language-server

    ## Zig
    zls

    ## Yaml
    yaml-language-server

    ## Java
    jdt-language-server
  ];
in
{
  nvim = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };
}
