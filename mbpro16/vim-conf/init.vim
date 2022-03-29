syntax enable
filetype plugin indent on
set clipboard=unnamed

if $compatible
  set nocompatible " Be iMproved
endif

set rtp+=~/.vim/
runtime! userautoload/init/*.vim
runtime! userautoload/dein/*.vim

let g:tex_flavor = 'latex'
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = expand('~/.cache/dein/repos/github.com/Shougo/dein.vim')

set rtp+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml('~/.vim/userautoload/dein/plugins.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/userautoload/dein/lazy_plug.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

