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
set complete-=i
set display+=lastline
set equalalways " Split windows are always equal size
set expandtab
set hlsearch
set incsearch
set laststatus=2
set number
set ruler
set shiftwidth=2 " Number of spaces to use for each step of (auto) indent.
set showcmd " Show (partial) command in status line.
set showmode " Put a mode message in the last line
set smarttab
set splitbelow " Put horizontal split window below of the current one
set splitright " Put vertical split window right of the current one
set tabstop=2 " Number of spaces in a tab
set textwidth=0 " Maximum numbers of characters in a line (breaks at
                " whitespace to get this length.
set ttimeout
set ttimeoutlen=100
set wildmenu

noremap <Tab> :bn<CR>
