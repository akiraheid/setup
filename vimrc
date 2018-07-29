execute pathogen#infect()

if has('autocmd')
    filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

set autoindent " Copy indent from current line when starting a new line
set autoread " Automatically read in the file again if it changes outside
             " vim.
set background=dark " Use colors good on a dark background
set colorcolumn=81 " Highlight the column
set complete-=i " Keyword completion. Used with C-P or C-N.
                " Default:
                "  . Current buffer
                "  w Buffers from other windows
                "  b Other loaded buffers in the buffer list
                "  u Unloaded buffers in the buffer list
                "  t Tag completion
                " Removed:
                "  i Current and included files
set display+=lastline
set display+=uhex
set equalalways " Split windows are always equal size
set hlsearch incsearch
set laststatus=2
set noswapfile
set number showmode
set splitbelow splitright
set t_Co=256
set textwidth=0
set ttimeout ttimeoutlen=100
set wildmenu

" Status line stuff
set ruler showcmd statusline=%f\ %r%m%=%c,%l\ %p\%%

" Spaces > tabs
set expandtab shiftwidth=4 softtabstop=4 smarttab

" Syntastic stuff
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_javascript_checkers=['eslint']

" Match commands
:match ErrorMsg '\s\+$' " Trailing whitespace

" Highlights
highlight ColorColumn ctermbg=235 guibg=#2c2d27
highligh CursorLine ctermbg=235 guibg=#2c2d27

" Buffer navigation shortcuts
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
