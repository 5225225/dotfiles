{ pkgs, vim-capnp, base16-vim, idris2-nvim, ... }:
let
  vp = pkgs.vimPlugins;
in
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
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
      (pkgs.vimUtils.buildVimPlugin {
        name = "idris2-nvim";
        src = idris2-nvim;
      })
    ];
    extraConfigLua = ''
      require('idris2').setup({})
    '';
    extraConfigVim = ''
      set nobackup
      set noswapfile
      filetype plugin indent off
      set mouse=

      set expandtab
      set shiftwidth=4
      set softtabstop=4
      set autoindent
      set smarttab

      set number

      set termguicolors
      let tinted_background_transparent=1
      set background=dark
      colorscheme base16-tube

      filetype plugin on
      syntax on

      set tw=99

      set modeline
      set modelines=5

      set backspace=indent,eol,start

      set incsearch
      set autoread

      set laststatus=2

      set smartcase

      set spell
      set wrapscan

      set clipboard^=unnamed

      set ttimeout
      set ttimeoutlen=50

      set ruler
      set showcmd
      set wildmenu

      set gdefault

      set foldmethod=syntax
      set foldnestmax=1

      let g:netrw_dirhistmax=0

      let &t_SI = "\<esc>[6 q"
      let &t_SR = "\<esc>[4 q"
      let &t_EI = "\<esc>[2 q"
    '';
  };
}
