execute pathogen#infect()

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

set autoindent
set autoread
set complete-=i
set display+=lastline
set hlsearch
set incsearch
set laststatus=2
set number
set ruler
set shiftwidth=2 tabstop=2 expandtab
set showcmd
set smarttab
set ttimeout
set ttimeoutlen=100
set wildmenu
