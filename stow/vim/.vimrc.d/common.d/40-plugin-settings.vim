"----------------------------"
" Plugin Settings (non-maps) "
"----------------------------"
" Ctrl-P Settings
let runtimepath = $HOME.'/.'.g:vimdist.'/bundle/ctrlp.vim'
set tags+=doc/tags
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_extensions = ['buffertag', 'dir', 'line']
let g:ctrlp_show_hidden=1
" Startify stuff
function s:my_sessions()
    let s_files = split(globpath('./doc/sessions', '*'), '\n')
    return map(s_files, '{"line": v:val, "cmd": "source". v:val }')
endfunction
let g:startify_lists = [
	    \ { 'header': ['   Doc Sessions'],	'type': function('s:my_sessions') },
	    \ { 'type': 'files',	'header': ['   MRU']            },
	    \ { 'type': 'dir',		'header': ['   MRU '. getcwd()] },
	    \ { 'type': 'sessions',	'header': ['   Sessions']       },
	    \ { 'type': 'bookmarks',	'header': ['   Bookmarks']      },
	    \ { 'type': 'commands',	'header': ['   Commands']       },
	    \ ]
" Bufferline Settings
let g:bufferline_solo_highlight = 0
let g:bufferline_always_show_bufferline = 1

" vim: set ts=8 sw=4 tw=78 et :
