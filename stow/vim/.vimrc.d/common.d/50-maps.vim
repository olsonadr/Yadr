"============"
" Maps/Binds "
"============"
" maps
nnoremap <silent> <localleader>ml :call AppendModeline()<CR>
"map <silent> <c-f> :call Format()<CR>
nmap <S-h> :bp<CR>
nmap <S-l> :bn<CR>
nmap <C-s> :w<CR>
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <leader>qq :qa<CR>
" imaps
imap <A-BS> <C-W>
"inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
imap <localleader>cp <Esc>:execute 'normal 0vg_"+y'<CR>
" Use jk for esc to quickly exit insert 
inoremap jk <ESC>
" abbreviations (and <c-b> for optional abbrevs)
inoremap <c-b> <c-v><c-a><c-]>
iab date <c-r>=strftime("%F")<CR>
iab program <Esc>mz:execute FileHeading()<CR>`zjjjj$A
iab function <Esc>mz:execute FunctionHeading()<CR>`zj$A

