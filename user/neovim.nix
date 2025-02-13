{
  pkgs,
  vim-capnp,
  base16-vim,
  ...
}: let
  vp = pkgs.vimPlugins;
in {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    impureRtp = false;
    wrapRc = true;
    performance = {
      byteCompileLua.enable = true;
      combinePlugins.enable = true;
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
        };
      };
    };
    extraPlugins = [
      vp.rust-vim
      vp.vim-wayland-clipboard
      vp.vim-nix
      vp.vim-ledger
      vp.nvim-lspconfig
      vp.nui-nvim
      vp.vim-glsl
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-capnp";
        src = vim-capnp;
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "base16-vim";
        src = base16-vim;
      })
    ];
    extraConfigVim = ''
      set mouse=

      set expandtab
      set shiftwidth=4
      set softtabstop=4

      set number

      let tinted_background_transparent=1
      colorscheme base16-tube

      set tw=99

      set smartcase

      set spell

      set clipboard^=unnamed

      set gdefault

      set foldmethod=syntax
      set foldnestmax=1

      let g:netrw_dirhistmax=0
    '';
  };
}
