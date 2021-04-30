syntax enable
filetype plugin indent on

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

set clipboard=unnamed

let g:tex_flavor = 'latex'

call plug#begin('~/.local/share/nvim/plugged')
Plug 'lervag/vimtex'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'copy/deoplete-ocaml'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
Plug 'vimsence/vimsence'
Plug 'racer-rust/vim-racer'
call plug#end()

let g:deoplete#enable_at_startup = 1
let g:LanguageClient_serverCommands = {
    \ 'ruby': ['solargraph', 'stdio'],
\}
call deoplete#custom#var('omni', 'input_patterns', {
    \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
\})

" other completion sources suggested to disable
call deoplete#custom#option('ignore_sources', {})
call deoplete#custom#option('ignore_sources.ocaml', ['buffer', 'around', 'member', 'tag'])

" no delay before completion
call deoplete#custom#option('auto_complete_delay', 0)


let g:airline_section_b = '%{strftime("%c")}'
let g:airline_theme = 'papercolor'
let g:airline#extensions#tabline#enabled = 1



let g:vimtex_compiler_latexmk = {
      \ 'background': 1,
      \ 'build_dir': 'out',
      \ 'continuous': 1,
      \ 'options': [  ],
      \}
let g:vimtex_quickfix_open_on_warning = 0

nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_powerline_fonts = 1

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

map <C-t> :NERDTreeToggle<CR>

noremap <silent><C-h> <C-w>h                                    
noremap <silent><C-j> <C-w>j                                                                                                                                                                                                                                                          
noremap <silent><C-k> <C-w>k                                                                              
noremap <silent><C-l> <C-w>l 

"カッコ補完: { ( [
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap () ()
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap [ []<ESC>i
inoremap [<Enter> []<Left><CR><ESC><S-o>

"補完: ' " <
inoremap '' ''
inoremap ' ''<ESC>i
inoremap "" ""
inoremap " ""<ESC>i


"インサートモードのままカーソル移動
inoremap <C-f> <C-g>U<Right>
inoremap <C-f><C-f> <C-g>U<ESC><S-a>

" --------------------------------
" syntastic
" --------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [
  \ 'ruby', 'javascript','coffee', 'scss', 'html', 'haml', 'slim', 'sh',
  \ 'spec', 'vim', 'zsh', 'sass', 'eruby'] }

let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_coffee_checkers = ['coffeelint']
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_rust_checkers = ['cargo']

let g:syntastic_error_symbol='✗'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_warning_symbol = '⚠'
let g:racer_experimental_completer = 1


