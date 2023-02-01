set nowrap

set encoding=UTF-8
set hlsearch
set ignorecase
set smartcase

set autoindent
set number
set ruler


set wildmenu
set showcmd

set shiftwidth=4
set softtabstop=4
set expandtab
set tabstop=4
set smarttab

autocmd FileReadPost,BufAdd,BufEnter,BufNew,BufNewfile,BufRead * filetype detect

autocmd Filetype yaml setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
autocmd Filetype json setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
