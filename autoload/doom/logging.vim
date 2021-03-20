"================================================
" logging.vim - Doom Nvim Logging system
" Author: NTBBloodbath
" License: MIT
"================================================

function! doom#logging#init()
    if g:doom_logging != 0
        let today = strftime('%c')
        let boot_msg = '['.today.'] - Starting Doom Nvim '.g:doom_version.' ...'
        try
            exec ':silent !echo " " >> $HOME/.doom-nvim/logs/doom.log'
            exec ':silent !echo '.boot_msg.' >> $HOME/.doom-nvim/logs/doom.log'
        catch
            echo 'Cannot write on_start log message'
            exec ':!touch $HOME/.doom-nvim/logs/doom.log'
        endtry
    endif
endfunction

function! doom#logging#message(type, msg, level)
    " + : doom nvim internal
    " * : external command
    " ? : Prompt
    " ! : Error
    " !!! : CRITICAL
    let output = ''
    if g:doom_logging != 0
        " Generate log message
        if a:type ==# '!'
            let output .= '[\!] - ' . a:msg
        elseif a:type ==# '+'
            let output .= '[+] - ' . a:msg
        elseif a:type ==# '*'
            let output .= '[*] - ' . a:msg
        elseif a:type ==# '?'
            let output .= '[?] - ' . a:msg
        elseif a:type ==# '!!!'
            let output .= '[\!\!\!] = ' . a:msg
        endif

        try
            if g:doom_logging >= a:level
                if g:doom_logging == 3
                    echo output
                endif
                exec ":silent !echo '".output."' >> $HOME/.doom-nvim/logs/doom.log"
            endif
        catch
            let err_msg = '[!] - Cannot save: ' . a:msg . ''
            exec ':silent !echo '.err_msg.' >> $HOME/.doom-nvim/logs/doom.log'
        endtry
    endif
endfunction
