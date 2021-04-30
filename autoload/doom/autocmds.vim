function! doom#autocmds#init() abort
    augroup doom_core
        " Load config
        call doom#logging#message('+', 'doom.autocmds.init called', 2)
        if g:doom_relative_num
            autocmd BufEnter,WinEnter * if &nu | set rnu | endif
            autocmd BufLeave,WinLeave * if &nu | set nornu | endif
        endif

        autocmd BufNewFile,BufRead doomrc set filetype=vim
        autocmd BufNewFile,BufEnter * set cpoptions+=d
        " ensure every file does full syntax highlight
        autocmd BufEnter * :syntax sync fromstart
    augroup END

    " Compile new plugins changes at save
    autocmd BufWritePost init.lua,doomrc PackerCompile profile=true

    " Disable tabline on Dashboard
    autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2

    " Automatically enter insert mode on new terminals
    augroup term_insert
        autocmd TermOpen * startinsert
    augroup END

    " Set autosave
    if g:doom_autosave ==# 1
        autocmd TextChanged,TextChangedI <buffer> silent! write
    endif

    " Format on save
    " NOTE: Requires neoformat to be enabled!
    if g:doom_fmt_on_save ==# 1
        autocmd BufWritePre * undojoin | Neoformat
    endif

    " Preserve last editing pos
    if g:doom_preserve_edit_pos ==# 1
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \     exe "normal! g`\"" |
                    \ endif
    endif

    " Set up vim_buffer_previewer in telescope if enabled
    if index(g:doom_disabled_modules, 'fuzzy') == -1 || index(g:doom_disabled_plugins, 'telescope') == -1
        autocmd User TelescopePreviewerLoaded setlocal wrap
    endif
endfunction
