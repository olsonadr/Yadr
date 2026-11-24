
" Must come first: with "-u file" vim starts in compatible mode, which breaks the
" line continuations used below (E10/E697).
if &compatible | set nocompatible | endif
let g:dots_root = empty($SHELL_DOTS_ROOT) ? $HOME : $SHELL_DOTS_ROOT
let g:vimdist='vim'

execute 'source' fnameescape(g:dots_root . '/.vimrc_common')

" Colorscheme from plugin
silent! colorscheme palenight
let g:palenight_terminal_italics=1

"set term=screen-256color-bce
