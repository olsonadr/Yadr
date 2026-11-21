"Plugin-related config"

"-------------"
" Plugin Maps "
"-------------"
" Easymotion
map <Leader> <Plug>(easymotion-prefix)
map <Leader><CR> <Plug>(easymotion-jumptoanywhere)
map <Leader><Leader>j <Plug>(easymotion-jumptoanywhere)
" NERDTree
map <C-\> :NERDTreeToggle<CR>
" surround.vim
map gsa <Plug>Ysurround
map gsd <Plug>Dsurround
map gsr <Plug>Csurround

if g:vimdist == "vim"
    "" vim specific plugin maps
elseif g:vimdist == "nvim"
    "" nvim specific plugins maps
    " Leap
    map s <Plug>(leap)
    map S <Plug>(leap)
    "nmap S <Plug>(leap-from-window)
    "nmap S <Plug>(leap-anywhere)
    map <Leader>s <Plug>(leap-anywhere)
endif

