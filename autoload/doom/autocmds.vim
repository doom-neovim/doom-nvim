function! doom#autocmds#init() abort
    augroup doom_core
        " Load config
        call doom#logging#message('+', 'doom#autocmds#init called', 2)
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
    autocmd BufWritePost plugins.lua PackerCompile

    autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2
endfunction
