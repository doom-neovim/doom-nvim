"================================================
" health.vim - Doom Nvim Health
" Author: NTBBloodbath
" License: GPLv2
"================================================

function! health#doom#check() abort
    lua Log_message('+', 'Checking Doom health ...', 2)
    lua require('doom.health').checkhealth()
endfunction
