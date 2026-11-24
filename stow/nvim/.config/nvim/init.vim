execute 'source' fnameescape((empty($SHELL_DOTS_ROOT) ? $HOME : $SHELL_DOTS_ROOT) . '/.nvimrc')
lua require("init")

