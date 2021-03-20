"================================================
" system.vim - Retrieve useful info about the OS
" Author: NTBBloodbath
" License: MIT
"================================================

" Force UTF-8 encoding
scriptencoding utf-8

function! doom#system#whichos()
    call doom#logging#message('+', 'Checking OS', 2)

    let g:doom_os = ''
    let g:doom_separator = ''

    if has('win32') || has('win64')
        let g:doom_os = 'windows'
        let g:doom_separator = '\\'
    elseif has('unix') && !has('macunix') && !has('win32unix')
        let g:doom_os = 'linux'
        let g:doom_separator = '/'
    elseif has('macunix')
        let g:doom_os = 'mac'
        let g:doom_separator = '/'
    elseif has('win32unix')
        let g:doom_os = 'cygwin'
        let g:doom_separator = '\\'
    else
        echo 'OS not recognized'
    endif

    call doom#logging#message('+', 'Current OS: '.g:doom_os, 2)
endfunction

function! doom#system#grepconfig(folder, filename, source) abort
    " Source file or returns the full path
    let fullpath = g:doom_root . a:folder . g:doom_separator . a:filename

    if filereadable(fullpath)
        if a:source ==# 1
            try
                execute 'source ' fullpath
                call doom#logging#message('+', 'Sourced file : '.a:filename, 2)
            catch
                call doom#logging#message('!', 'Failed sourcing '.a:filename, 1)
            endtry
        else
            call doom#logging#message('+', 'Returned '.a:filename.' path', 2)
            return fullpath
        endif
    endif
endfunction

function doom#system#grepfolder(folder) abort
    let fullpath = g:doom_root . a:folder

    try
        call doom#logging#message('+', 'Returned '.a:folder.' path', 2)
        return fullpath
    catch
        call doom#logging#message('!', 'Unable to return folder path', 1)
    endtry
endfunction

function! doom#system#grepdoc() abort
    let fullpath = g:doom_root . 'doc'

    try
        exe ':helptags ' . fullpath
    catch
        call doom#logging#message('!', 'Unable to create helptags', 1)
    endtry
endfunction

function! doom#system#checkupdates()
    try
        call doom#logging#message('+', 'Purging outdated plugin...', 2)
        execute ':PackerSync'
        call doom#logging#message('+', 'Done', 2)
    catch
        call doom#logging#message('!', 'Unable to update plugins', 1)
    endtry
endfunction
