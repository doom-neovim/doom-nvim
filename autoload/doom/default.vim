"================================================
" default.vim - Doom Nvim defaults
" Author: NTBBloodbath
" License: MIT
"================================================

" Force encoding to UTF-8
scriptencoding utf-8

function! doom#default#options() abort
    call doom#logging#message('+', 'doom#default#options called', 2)
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
    set hlsearch

    set mouse=a
    set laststatus=2
    set backspace=indent,eol,start
    set timeoutlen=200
    set clipboard+=unnamedplus
    set shortmess+=at

    let &expandtab = g:doom_expand_tabs
    let &tabstop = g:doom_indent
    let &softtabstop = g:doom_indent
    let &colorcolumn = g:doom_max_cols
    let &conceallevel = g:doom_conceallevel
    if g:doom_relative_num ==# 1
        set number relativenumber
    else
        set number
    endif
endfunction

function doom#default#loadGlob()
    " Set SPC as the mapleader
    let mapleader = ' '

    " NOTE: most of Doom Nvim plugins are written in Lua, their configs will
    " be loaded directly from packer.nvim configuration.

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
    let g:dashboard_session_directory = g:doom_root . 'sessions/'
    " let g:dashboard_custom_shortcut = {
    "             \ 'last_session'       : 'SPC q l',
    "             \ 'find_history'       : 'SPC s h',
    "             \ 'find_file'          : 'SPC s f',
    "             \ 'new_file'           : 'SPC f n',
    "             \ 'change_colorscheme' : 'SPC m c',
    "             \ 'find_word'          : 'SPC s w',
    "             \ 'book_marks'         : 'SPC m j',
    "             \ }
    let plugins_count = len(globpath('~/.local/share/nvim/site/pack/packer/start', '*', 0, 1))
    let g:dashboard_custom_footer = [
                \ 'Doom Nvim loaded '.plugins_count.' plugins'
                \]
    let g:dashboard_custom_header = [
                \ "=================     ===============     ===============   ========  ========",
                \ "\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //",
                \ "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||",
                \ "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||",
                \ "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||",
                \ "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||",
                \ "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||",
                \ "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||",
                \ "||_-' ||  .|/    || ||   \\|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||",
                \ "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||",
                \ "||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||",
                \ "||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||",
                \ "||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||",
                \ "||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||",
                \ "||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||",
                \ "||.=='    _-'                                                     `' |  /==.||",
                \ "=='    _-'                                                            \/   `==",
                \ "\   _-'                                                                `-_   /",
                \ " `''                              N e o v i m                             ``' ",
                \ "                                                                             ",
                \ ]
    " Header color
    hi! dashboardHeader   guifg=#676E95
    hi! dashboardCenter   guifg=#070508
    hi! dashboardShortcut guifg=#FFEC83
    hi! dashboardFooter   guifg=#676E95
endfunction
