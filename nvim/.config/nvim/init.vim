set noswapfile

set mouse=

set number

colorscheme base16-default
set background=dark

filetype plugin on
syntax on

set expandtab
set shiftwidth=4
set softtabstop=4
set autoindent
set smarttab

set tw=99

set modeline
set modelines=5

set ignorecase
set smartcase

set spell
set wrapscan

set clipboard^=unnamed

set ttimeout
set ttimeoutlen=50

set gdefault

set foldmethod=syntax
set foldnestmax=1

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


let g:vimwiki_list = [{'path': '~/sync/docs/wiki/src/', 'path_html': '~/sync/docs/wiki/html/'}]
let g:vimwiki_global_ext = 0
