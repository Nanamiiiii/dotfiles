syntax on
filetype plugin indent on
set clipboard=unnamed

if $compatible
  set nocompatible " Be iMproved
endif

set rtp+=~/.vim/

let g:tex_flavor = 'latex'

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' .. substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif

let s:dein_repo_dir = expand('~/.cache/dein')

if dein#load_state(s:dein_repo_dir)
  call dein#begin(s:dein_repo_dir)

  call dein#load_toml('~/.vim/userautoload/dein/plugins.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/userautoload/dein/lazy_plug.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

runtime! userautoload/init/*.vim
runtime! userautoload/dein/*.vim

