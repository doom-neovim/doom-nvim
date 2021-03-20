"================================================
" config.vim - Doom Nvim Config file load
" Author: NTBBloodbath
" License: MIT
"================================================

" Set proper syntax highlight for our doomrc
autocmd BufNewFile,BufRead doomrc set ft=vim

function! doom#config#checkBFC()
    " /home/user/.doom-nvim/doomrc
    if filereadable(g:doom_root . '/doomrc')
        let g:doom_bfc = 1
    else
        let g:doom_bfc = 0
    endif
endfunction

function! doom#config#loadBFC()
    " /home/user/.doom-nvim/doomrc
    if filereadable(g:doom_root . '/doomrc')
        try
            execute 'source ' . g:doom_root . '/doomrc'
            call doom#logging#message('+', 'Loading the BFC', 2)
        catch
            call doom#logging#message('!', 'Error while loading the BFC', 1)
        endtry
    else
        call doom#logging#message('+', 'No BFC file found', 2)
    endif
endfunction
