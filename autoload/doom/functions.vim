"================================================
" functions.vim - Doom Nvim functions
" Author: NTBBloodbath
" License: MIT
"================================================

function! doom#functions#checkplugin(plugin) abort
    if isdirectory(expand('$HOME') . '/.local/share/nvim/site/pack/packer/start/' . a:plugin)
        return 1
    else
        return 0
    endif
endfunction

" /home/user/.config/doom-nvim/autoload/functions.vim
function! doom#functions#get_root() abort
    call doom#logging#message('+', 'doom.functions.get_root called', 2)

    let full_root = expand('<sfile>:p')
    let root = full_root[:-22]

    return root
endfunction

function! doom#functions#quit_doom(write, force) abort
    try
        call doom#logging#message('*', 'Checking if the colorscheme was changed...', 2)
        let target = g:colors_name
        if target != g:doom_colorscheme
            exec ":!sed -i \"s/'".g:doom_colorscheme."'/'".target."'/\" $HOME/.config/doom-nvim/doomrc"
            call doom#logging#message('*', 'Colorscheme successfully changed', 2)
        else
            call doom#logging#message('*', 'No need to write colors (same colorscheme)', 2)
        endif
    catch
        call doom#logging#message('!', 'Unable to write to the BFC', 1)
    endtry

    exec ':silent !echo "[---] - Dumping :messages" >> $HOME/.config/doom-nvim/logs/doom.log'
    exec 'redir >> $HOME/.config/doom-nvim/logs/doom.log'
    exec ':silent messages'
    exec ':redir END'
    exec ':silent !echo " " >> $HOME/.config/doom-nvim/logs/doom.log'
    exec ':silent !echo "[---] - End of dump" >> $HOME/.config/doom-nvim/logs/doom.log'

    let quit_cmd = ''

    " Save current session if enabled
    if g:doom_autosave_sessions ==# 1
        exec ':SessionSave'
    endif

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
    exec ':silent !echo "# doom crash report" >> $HOME/.config/doom-nvim/logs/report.md'
    exec ':silent !echo "## Begin log dump" >> $HOME/.config/doom-nvim/logs/report.md'
    exec ':silent !echo | cat $HOME/.config/doom-nvim/logs/doom.log >> $HOME/.config/doom-nvim/logs/report.md'
    exec ':silent !echo "## End log dump" >> $HOME/.config/doom-nvim/logs/report.md'
    exec ':silent echo "Report created at $HOME/.config/doom-nvim/logs/report.md"'
endfunction
