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
set display+=lastline " The way text is displayed.
set display+=uhex			" Default:
											" Add:
											"  lastline Display as much of the last line as
											"						possible instead of @ symbols.
											"  uhex Display unprintable characters as <xx>
											"  instead of ^C and ~C.
set equalalways " Split windows are always equal size
set noexpandtab " In Insert mode, use the appropriate number of spaces to
								" insert a tab.
set statusline+=%f
set hlsearch " Highlight all pattern matches.
set incsearch " While searching, show the pattern as it is typed.
set laststatus=2 " Influences when the last window will have a status line
								 " Default:
								 "	1 Only if there are at least two windows
								 " Set:
								 "	2 Always
set noswapfile " Don't create a swap file.
set number " Show line numbers.
set ruler " Show the line and column of the cursor. Show the relative
					" position of the displayed text if there's room.
set shiftwidth=2 " Number of spaces to use for each step of (auto) indent.
set showcmd " Show (partial) command in status line.
set showmode " Put a mode message in the last line
set smarttab " In front of a line, insert 'shiftwidth' blanks.
set splitbelow " Put horizontal split window below of the current one
set splitright " Put vertical split window right of the current one
set t_Co=256 " 256 color setting
set tabstop=2 " Number of spaces in a tab
set textwidth=0 " Maximum numbers of characters in a line (breaks at
								" whitespace to get this length.
set ttimeout " Timeout on :mappings and keycodes
set ttimeoutlen=100 " Duration before timeout.
set wildmenu " Pressing 'wildchar' (<Tab>) to invoke completion shows
						 " possible matches.


" Syntastic stuff
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Match commands
:match ErrorMsg '\s\+$' " Trailing whitespace

" Highlights
highlight ColorColumn ctermbg=235 guibg=#2c2d27
highligh CursorLine ctermbg=235 guibg=#2c2d27

" Buffer navigation shortcuts
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
