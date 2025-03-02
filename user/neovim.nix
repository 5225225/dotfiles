{
  pkgs,
  config,
  inputs,
  ...
}:
let
  vp = pkgs.vimPlugins;
in
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    impureRtp = false;
    wrapRc = true;
    nixpkgs.useGlobalPackages = true;
    performance = {
      byteCompileLua.enable = true;
      combinePlugins.enable = true;
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
        };
      };
      treesitter = {
        enable = true;
        folding = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      rainbow-delimiters.enable = true;
    };
    extraPlugins = [
      vp.rust-vim
      vp.vim-nix
      vp.vim-ledger
      vp.nvim-lspconfig
      vp.nui-nvim
      vp.vim-fugitive
      (pkgs.vimUtils.buildVimPlugin {
        name = "tinted-vim";
        src = inputs.tinted-vim;
      })
    ];
    opts = {
      mouse = "";
      expandtab = true;
      shiftwidth = 4;
      softtabstop = 4;
      number = true;
      tw = 99;
      smartcase = true;
      spell = true;
      gdefault = true;
      foldmethod = "expr";
    };
    globals = {
      tinted_background_transparent = 1;
      netrw_dirhistmax = 0;
    };
    colorscheme = "base16-${config.scheme.slug}";
  };
}
