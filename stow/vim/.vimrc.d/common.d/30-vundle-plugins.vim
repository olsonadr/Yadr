" Skip plugin setup when Vundle is not present (e.g. a minimal remote deploy)
if !isdirectory(g:dots_root.'/.'.g:vimdist.'/bundle/Vundle.vim') | finish | endif
"-----------------------------"
" Vundle Settings/Plugin List "
"-----------------------------"
let &rtp .= ','.g:dots_root.'/.'.g:vimdist.'/bundle/Vundle.vim'
filetype on   " make sure filetype autocmds exist before turning them off (avoids E216)
filetype off
call vundle#begin()
let g:vundle#bundle_dir = g:dots_root.'/.'.g:vimdist.'/bundle/'
" vimdist-agnostic plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'bullets-vim/bullets.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'drewtempelmeyer/palenight.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'mhinz/vim-startify'
Plugin 'rdnetto/YCM-Generator'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
"Plugin 'Valloric/YouCompleteMe'
if g:vimdist == "vim"
    " vim specific plugins
    Plugin 'ap/vim-buftabline'
    Plugin 'justinmk/vim-sneak'
elseif g:vimdist == "nvim"
    " nvim specific plugins
    Plugin 'akinsho/bufferline.nvim'
    Plugin 'folke/tokyonight.nvim'
    Plugin 'folke/which-key.nvim'
    Plugin 'ggandor/leap.nvim'
    Plugin 'shrynx/line-numbers.nvim'
    Plugin 'neovim/nvim-lspconfig'
    Plugin 'nvim-treesitter/nvim-treesitter'
    Plugin 'octol/vim-cpp-enhanced-highlight'
    Plugin 'petertriho/nvim-scrollbar'
endif

call vundle#end()
filetype plugin indent on
let g:ycm_global_ycm_extra_conf = g:dots_root.'/.'.g:vimdist.'/.ycm_extra_conf.py'
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

