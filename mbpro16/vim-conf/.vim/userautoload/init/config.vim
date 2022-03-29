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

autocmd BufNewFile,BufRead * set expandtab
autocmd BufNewFile,BufRead * retab

autocmd FileType vue syntax sync fromstart
autocmd FileType eruby syntax sync fromstart
autocmd BufNewFile,BufRead *.{html,htm} set filetype=html
autocmd BufNewFile,BufRead *.html.erb set filetype=html.eruby
autocmd BufNewFile,BufRead *.{pug*} set filetype=pug
autocmd BufNewFile,BufRead *.{jade*} set filetype=pug
autocmd BufRead,BufNewFile *.scss set filetype=sass
autocmd BufRead,BufNewFile *.json set filetype=json
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.rb set filetype=ruby
autocmd BufRead,BufNewFile *.slim set filetype=slim
autocmd BufRead,BufNewFile *.js set filetype=javascript
autocmd BufRead,BufNewFile *.jsx set filetype=javascriptreact
autocmd BufRead,BufNewFile *.ts set filetype=typescript
autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
autocmd BufRead,BufNewFile jquery.*.js set filetype=javascript syntax=jquery
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.pug.javascript.css
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""

