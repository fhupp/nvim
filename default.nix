# { inputs }:
# final: prev:
{
  pkgs,
  lib,
  vimPlugins,
  vimUtils,
  callPackage,
  wrapNeovimUnstable,
  neovimUtils,
}:
# with lib;
let
  mkNvimPlugin = import ./mkNvimPlugin.nix {
    inherit vimUtils;
  };

  mkNeovim = callPackage ./mkNeovim.nix {
    inherit
      wrapNeovimUnstable
      neovimUtils
      ;
  };

  plugins = with vimPlugins; [
    nvim-treesitter.withAllGrammars

    firenvim

    # Lazy Loading
    lze
    lzextras

    # Colorschemes
    vim-moonfly-colors

    # Images
    image-nvim

    telescope-nvim

    # Git
    gitsigns-nvim
    neogit
    mini-diff

    lsp-format-nvim

    nvim-web-devicons

    autosave-nvim

    # Completions
    blink-cmp

    # Tab Bar
    bufferline-nvim

    # Status Line
    lualine-nvim

    # Start Page
    alpha-nvim

    # File Systems
    oil-nvim
    neo-tree-nvim

    # LaTeX
    vimtex
    (mkNvimPlugin inputs.ltex-ls-nvim-src "ltex-ls.nvim")
    ltex_extra-nvim

    # Haskell
    haskell-tools-nvim

    # Lean
    lean-nvim

    # Rust
    crates-nvim

    (mkNvimPlugin inputs.direnv-nvim-src "direnv.nvim")
    (mkNvimPlugin inputs.neominimap-nvim-src "neominimap.nvim")
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
  ];
in
{
  nvim = mkNeovim {
    inherit
      plugins
      extraPackages
      ;
  };
}
