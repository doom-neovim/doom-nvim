"================================================
" gui.vim - Doom Nvim Gui settings
" Author: NTBBloodbath
" License: MIT
"================================================

" If no colorscheme was established then fallback to defaults
if g:doom_colorscheme !=# ''
    try
        exec 'set background=' . g:doom_colorscheme_bg
        exec 'colorscheme ' . g:doom_colorscheme
    catch
        call doom#logging#message('!', 'Colorscheme not found', 1)
        exec 'colorscheme ' . g:doom_colorscheme
    endtry
else
    call doom#logging#message('!', 'Forced default colorscheme', 1)
    exec 'colorscheme default'
endif

" If guicolors are enabled
if g:doom_enable_guicolors == 1
    if has('nvim')
        set termguicolors
    endif
    if exists('+termguicolors')
        set termguicolors
    elseif exists('+guicolors')
        set guicolors
    endif
endif
