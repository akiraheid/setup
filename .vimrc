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
set complete-=i " Keyword completion. Used with C-P or C-N.
                " Default:
                "  . Current buffer
                "  w Buffers from other windows
                "  b Other loaded buffers in the buffer list
                "  u Unloaded buffers in the buffer list
                "  t Tag completion
                " Removed:
                "  i Current and included files
set display+=lastline, uhex " The way text is displayed.
                            " Default:
                            " Add:
                            "  lastline Display as much of the last line as
                            "           possible instead of @ symbols.
                            "  uhex Display unprintable characters as <xx>
                            "  instead of ^C and ~C.
set equalalways " Split windows are always equal size
set expandtab " In Insert mode, use the appropriate number of spaces to
              " insert a tab.
set hlsearch " Highlight all pattern matches.
set incsearch " While searching, show the pattern as it is typed.
set laststatus=2 " Influences when the last window will have a status line
                 " Default:
                 "  1 Only if there are at least two windows
                 " Set:
                 "  2 Always
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
set tabstop=2 " Number of spaces in a tab
set textwidth=0 " Maximum numbers of characters in a line (breaks at
                " whitespace to get this length.
set ttimeout " Timeout on :mappings and keycodes
set ttimeoutlen=100 " Duration before timeout.
set wildmenu " Pressing 'wildchar' (<Tab>) to invoke completion shows
             " possible matches.

" Buffer navigation shortcuts
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
