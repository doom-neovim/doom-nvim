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
            if g:doom_logging == 3
                echo boot_msg
            endif
            exec ':silent !echo " " >> $HOME/.config/doom-nvim/logs/doom.log'
            exec ":silent !echo \"".boot_msg."\" >> $HOME/.config/doom-nvim/logs/doom.log"
        catch
            echo 'Cannot write on_start log message'
            exec ':!touch $HOME/.config/doom-nvim/logs/doom.log'
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
                    " If it is an error then use echoerr
                    if output =~ '\!'
                        echoerr output
                    else
                        echo output
                    endif
                endif
                exec ":silent !echo '".output."' >> $HOME/.config/doom-nvim/logs/doom.log"
            endif
        catch
            let err_msg = '[!] - Cannot save: ' . a:msg . ''
            echoerr err_msg
            exec ':silent !echo '.err_msg.' >> $HOME/.config/doom-nvim/logs/doom.log'
        endtry
    endif
endfunction
