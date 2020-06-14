execute pathogen#infect()

if has('autocmd')
	filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
	syntax enable
endif

" Automatically read in the file again if it changes outside
" vim.
set autoread

set background=dark " Use colors good on a dark background
set colorcolumn=81 " Highlight the column

" Keyword completion. Used with C-P or C-N.
" Default:
"  . Current buffer
"  w Buffers from other windows
"  b Other loaded buffers in the buffer list
"  u Unloaded buffers in the buffer list
"  t Tag completion
" Removed:
"  i Current and included files
set complete-=i

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

" Tabs > space
set autoindent
set noexpandtab " Use only tabs
set nosmarttab " Disable inserting spaces instead of tabs
set shiftwidth=4
set smartindent
set softtabstop=0 " Disable fill with spaces
set tabstop=4

" Syntastic stuff
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'eslint .'

" Match commands
:match ErrorMsg '\s\+$' " Trailing whitespace

" Highlights
highlight ColorColumn ctermbg=235 guibg=#2c2d27
highligh CursorLine ctermbg=235 guibg=#2c2d27

" Buffer navigation shortcuts
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
