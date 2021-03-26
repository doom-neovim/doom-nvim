"================================================
" default.vim - Doom Nvim defaults
" Author: NTBBloodbath
" License: MIT
"================================================

" Force encoding to UTF-8
scriptencoding utf-8

function! doom#default#options() abort
    call doom#logging#message('+', 'doom.default.options called', 2)
    " Set colorscheme
    exe "colorscheme ".g:doom_colorscheme
    exe "set background=".g:doom_colorscheme_bg
    " Set default options
    syntax on
    filetype plugin indent on
    set encoding=utf-8

    set wildmenu
    set autoread
    set autoindent
    set smartindent
    set smarttab
    set splitright
    set splitbelow
    set noswapfile
    set noshowmode
    set nowrap

    set hidden
    set hlsearch
    set mouse=a
    set laststatus=2
    set backspace=indent,eol,start
    set updatetime=100
    set timeoutlen=200
    set completeopt+=menu,menuone,preview,noselect
    set clipboard+=unnamedplus
    set shortmess+=at

    set inccommand=split
    set signcolumn=yes
    set scrolloff=4
    set path=**

    let &expandtab = g:doom_expand_tabs
    let &tabstop = g:doom_indent
    let &shiftwidth = g:doom_indent
    let &softtabstop = g:doom_indent
    let &colorcolumn = g:doom_max_columns
    let &conceallevel = g:doom_conceallevel
    if g:doom_relative_num ==# 1
        set number relativenumber
    else
        set number
    endif
endfunction

function doom#default#loadGlob()
    " Set a custom command to update Doom Nvim
    " can be called by using :DoomUpdate
    command DoomUpdate !git -C ~/.config/doom-nvim/ stash -q && git -C ~/.config/doom-nvim/ pull && git -C ~/.config/doom-nvim/ stash pop -q

    " Set SPC as the mapleader
    let mapleader = ' '

    " Indent Lines, disabled until this issue is fixed
    " https://github.com/neovim/neovim/issues/14050
    " let g:indent_blankline_enabled = g:doom_show_indent
    " let g:indent_blankline_char_list = ['|', '¦', '┆', '┊']
    " Disable indent lines on dashboard and help
    " let g:indent_blankline_filetype_exclude = ['help', 'dashboard', 'NvimTree', 'minimap']
    " Disable indent line on first indent
    " let g:indent_blankline_show_first_indent_level = v:false
    " If treesitter is not disabled, then ...
    " if index(g:doom_disabled_plugins, 'treesitter') == -1
    "     " When on, use treesitter to determine the current context. Then show
    "     " the indent character in a different highlight. Might be slower.
    "     " If this option slows your Neovim, just turn off the variable
    "     " g:doom_show_indent_context
    "     let g:indent_blankline_show_current_context = g:doom_show_indent_context
    "     " use treesitter to calculate indentation when possible.
    "     let g:indent_blankline_use_treesitter = 1
    " endif

    " NOTE: most of Doom Nvim plugins are written in Lua, their configs
    " resides in the `lua/configs/` directory.

    " nvim-tree.lua
    " NOTE: The rest of the tree config resides in a vim file.
    let g:nvim_tree_hide_dotfiles = g:doom_show_hidden
    let g:nvim_tree_width = g:doom_sidebar_width
    " Set Tree Explorer side to be opposed at the tagbar.
    " tabar left / tree explorer right | tagbar right / tree explorer left
    if g:doom_tagbar_left ==# 1
        let g:nvim_tree_side = 'right'
    else
        let g:nvim_tree_side = 'left'
    endif

    " Dashboard
    let g:dashboard_session_directory = g:doom_root . 'sessions'
    let g:dashboard_default_executive = 'telescope'
    let g:dashboard_custom_shortcut = {
                \ 'last_session'       : 'SPC s l',
                \ 'find_history'       : 'SPC f h',
                \ 'find_file'          : 'SPC f f',
                \ 'new_file'           : 'SPC c n',
                \ 'change_colorscheme' : 'SPC t c',
                \ 'find_word'          : 'SPC f a',
                \ 'book_marks'         : 'SPC f b',
                \ }
    let plugins_count = len(globpath('~/.local/share/nvim/site/pack/packer/start', '*', 0, 1))
    let g:dashboard_custom_footer = [
                \ 'Doom Nvim loaded '.plugins_count.' plugins'
                \]
    let g:dashboard_custom_header = [
                \ "=================     ===============     ===============   ========  ========",
                \ "\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //",
                \ "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||",
                \ "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||",
                \ "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||",
                \ "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||",
                \ "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||",
                \ "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||",
                \ "||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||",
                \ "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||",
                \ "||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||",
                \ "||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||",
                \ "||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||",
                \ "||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||",
                \ "||   .=='    _-'          `-__\\._-'         `-_./__-'         `' |. /|  |   ||",
                \ "||.=='    _-'                                                     `' |  /==.||",
                \ "=='    _-'                        N E O V I M                         \\/   `==",
                \ "\\   _-'                                                                `-_   /",
                \ " `''                                                                      ``'  ",
                \ "                                                                               ",
                \ ]
    " Header color
    hi! dashboardHeader   guifg=#586268
    hi! dashboardCenter   guifg=#51afef
    hi! dashboardShortcut guifg=#9788b9
    hi! dashboardFooter   guifg=#586268
endfunction
