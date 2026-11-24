
" Must come first: with "-u file" vim starts in compatible mode, which breaks the
" line continuations used below (E10/E697).
if &compatible | set nocompatible | endif
let g:dots_root = empty($SHELL_DOTS_ROOT) ? $HOME : $SHELL_DOTS_ROOT
let g:vimdist = 'nvim'

execute 'source' fnameescape(g:dots_root . '/.vimrc_common')

" Colorscheme from plugin
silent! colorscheme tokyonight-night
"colorscheme tokyonight-moon
"colorscheme tokyonight-storm
"colorscheme tokyonight-day
"colorscheme tokyonight

" In your init.lua or init.vim
lua << EOF
pcall(function() require("bufferline").setup{} end)
EOF
let g:bufferline_solo_highlight = 0
let g:bufferline_always_show_bufferline = 1

" vim: set ts=8 sw=4 tw=78 et :
