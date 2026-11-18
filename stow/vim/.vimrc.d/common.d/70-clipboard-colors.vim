"=============="
" Misc Verbose "
"=============="
" Fix neovim colors
if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 -- based on patch 7.4.1770 (`guicolors` option)
if (has("termguicolors"))
	set termguicolors
endif

" Fix clipboard on X/wayland/WSL
let env_tmux=$TMUX
let env_display=$DISPLAY
let env_wayland_display=$WAYLAND_DISPLAY
if system('uname -r') =~ "microsoft"
 augroup Yank
   autocmd!
   autocmd TextYankPost * :call system('clip.exe ',@")
 augroup END
elseif len(env_tmux) != 0
    let g:clipboard = "tmux"
elseif len(env_display) != 0
    let g:clipboard = "xclip"
    " let g:clipboard = {
    "    \   'name': 'xclip-custom',
    "    \   'copy': {
    "    \      '+': 'xclip -quiet -i -selection clipboard',
    "    \      '*': 'xclip -quiet -i -selection primary',
    "    \    },
    "    \   'paste': {
    "    \      '+': 'xclip -o -selection clipboard',
    "    \      '*': 'xclip -o -selection primary',
    "    \   },
    "    \ }
elseif len(env_wayland_display) != 0
    let g:clipboard = 'wl-copy'
    " let g:clipboard = {
    "     \   'name': 'wl-copy-custom',
    "     \   'copy': {
    "     \      '+': 'wl-copy',
    "     \      '*': 'wl-copy -p',
    "     \    },
    "     \   'paste': {
    "     \      '+': 'wl-paste',
    "     \      '*': 'wl-paste -p',
    "     \   },
    "     \ }
endif

" vim: set ts=8 sw=4 tw=78 et :
