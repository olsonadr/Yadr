"=============="
" Misc Options "
"=============="
syntax on
set sessionoptions=blank,curdir,folds,help,tabpages,winpos
set clipboard+=unnamedplus
set autoindent
set tabstop=4
set softtabstop=2
set shiftwidth=2
set noexpandtab
set mouse=a
set background=dark
set number
set completeopt-=preview
set shortmess+=c
set foldmethod=indent   " fold based on indent
set nofoldenable
set nocompatible
set cc=81
silent! colorscheme palenight
let g:palenight_terminal_italics=1
" Please no tabs
"set paste&
set expandtab
"" Add relative line numbers
"let &stc='%#NonText#%{&nu?v:lnum:""} %=%{v:relnum} '
set relativenumber
"Paste stuff
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

