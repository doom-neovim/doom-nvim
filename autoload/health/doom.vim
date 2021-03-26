"================================================
" health.vim - Doom Nvim Health
" Author: NTBBloodbath
" License: MIT
"================================================

function! health#doom#check() abort
    call doom#logging#message('+', 'Checking Doom health ...', 2)
    lua require('doom.health').checkhealth()
endfunction
