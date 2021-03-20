"================================================
" functions.vim - Doom Nvim functions
" Author: NTBBloodbath
" License: MIT
"================================================

function! doom#functions#checkplugin(plugin) abort
    if isdirectory('~/.local/share/nvim/site/pack/packer/start/' . a:plugin)
        echo 'Plugin found'
    else
        echo 'Plugin not found'
    endif
endfunction

" /home/user/.doom-nvim/autoload/functions.vim
function! doom#functions#get_root() abort
    call doom#logging#message('+', 'doom#functions#get_root called', 2)

    let full_root = expand('<sfile>:p')
    let root = full_root[:-22]

    return root
endfunction


function! doom#functions#quit_doom(write, force) abort
    try
        call doom#logging#message('*', 'Checking if the colorscheme was changed...', 2)
        let target = g:colors_name
        if target != g:doom_colorscheme
            exec ":!sed -i \"s/'".g:doom_colorscheme."'/'".target."'/\" $HOME/.doom-nvimrc"
            call doom#logging#message('*', 'Colorscheme successfully changed', 2)
        else
            call doom#logging#message('*', 'No need to write colors (same colorscheme)', 2)
        endif
    catch
        call doom#logging#message('!', 'Unable to write to the BFC', 1)
    endtry

    exec ':silent !echo "[---] - Dumping :messages" >> $HOME/.doom-nvim/logs/doom.log'
    exec 'redir >> $HOME/.doom-nvim/logs/doom.log'
    exec ':silent messages'
    exec ':redir END'
    exec ':silent !echo " " >> $HOME/.doom-nvim/logs/doom.log'
    exec ':silent !echo "[---] - End of dump" >> $HOME/.doom-nvim/logs/doom.log'

    let quit_cmd = ''

    if a:write == 1
        let quit_cmd .= 'wa | '
    endif
    if a:force == 0
        exec quit_cmd.'q!'
    elseif a:force == 1
        exec quit_cmd.'qa!'
    endif
endfunction

" Create a markdown report to use when a bug occurs,
" useful for debugging issues.
function! doom#functions#createReport() abort
    exec ':silent !echo "# doom crash report" >> $HOME/.doom-nvim/logs/report.md'
    exec ':silent !echo "## Begin log dump" >> $HOME/.doom-nvim/logs/report.md'
    exec ':silent !echo | cat $HOME/.doom-nvim/logs/doom.log >> $HOME/.doom-nvim/logs/report.md'
    exec ':silent !echo "## End log dump" >> $HOME/.doom-nvim/logs/report.md'
    exec ':silent echo "Report created at $HOME/.doom-nvim/logs/report.md"'
endfunction
