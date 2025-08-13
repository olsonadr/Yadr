
let g:vimdist = 'nvim'

source ~/.vimrc_common

" Colorscheme from plugin
colorscheme tokyonight-night
"colorscheme tokyonight-moon
"colorscheme tokyonight-storm
"colorscheme tokyonight-day
"colorscheme tokyonight

" In your init.lua or init.vim
lua << EOF
require("bufferline").setup{}
EOF
let g:bufferline_solo_highlight = 0
let g:bufferline_always_show_bufferline = 1

" vim: set ts=8 sw=4 tw=78 et :
